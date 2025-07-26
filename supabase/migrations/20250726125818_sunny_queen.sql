/*
  # Initial Database Schema for African Meal Planner

  1. New Tables
    - `users` - Custom user model with African cuisine preferences
    - `user_profiles` - Extended user profile information
    - `health_conditions` - Health conditions affecting meal planning
    - `allergies` - Food allergies and intolerances
    - `dietary_preferences` - Dietary preferences and restrictions
    - `fitness_goals` - User fitness and health goals
    - `achievements` - User achievements and badges
    - `user_achievements` - Track user earned achievements
    - `regions` - African regions for recipe categorization
    - `cuisines` - Specific cuisines within regions
    - `ingredients` - Ingredients used in African cooking
    - `recipes` - African recipes with detailed information
    - `recipe_ratings` - User ratings for recipes
    - `user_recipes` - User interactions with recipes
    - `recipe_collections` - User-created recipe collections
    - `cooking_tips` - Cooking tips and techniques
    - `meal_plans` - User meal plans
    - `meal_plan_entries` - Individual meal entries in plans
    - `shopping_lists` - User shopping lists
    - `shopping_list_items` - Items in shopping lists
    - `ai_recommendations` - AI-generated recommendations
    - `user_preference_profiles` - AI-learned user preferences
    - `ai_interactions` - Track AI interactions for learning
    - `cultural_insights` - AI-generated cultural insights

  2. Security
    - Enable RLS on all user-related tables
    - Add policies for authenticated users to access their own data
    - Add policies for public read access to reference data

  3. Features
    - Full-text search capabilities
    - Automatic timestamp updates
    - Rating calculation triggers
    - Comprehensive indexing for performance
*/

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Users table (custom user model)
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  username text UNIQUE NOT NULL,
  first_name text DEFAULT '',
  last_name text DEFAULT '',
  phone_number text,
  date_of_birth date,
  gender text CHECK (gender IN ('M', 'F', 'O', 'P')),
  height float CHECK (height > 0 AND height < 300),
  weight float CHECK (weight > 0 AND weight < 500),
  country text,
  city text,
  location text,
  cooking_level text DEFAULT 'beginner' CHECK (cooking_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
  family_size integer DEFAULT 1 CHECK (family_size > 0 AND family_size <= 20),
  bio text,
  avatar text,
  notifications_enabled boolean DEFAULT true,
  location_enabled boolean DEFAULT true,
  offline_mode boolean DEFAULT false,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  last_active timestamptz DEFAULT now()
);

-- Health conditions
CREATE TABLE IF NOT EXISTS health_conditions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  description text DEFAULT '',
  dietary_restrictions text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

-- Allergies
CREATE TABLE IF NOT EXISTS allergies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  description text DEFAULT '',
  severity_level text DEFAULT 'moderate' CHECK (severity_level IN ('mild', 'moderate', 'severe', 'life_threatening')),
  common_foods text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

-- Dietary preferences
CREATE TABLE IF NOT EXISTS dietary_preferences (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  description text DEFAULT '',
  allowed_foods text DEFAULT '',
  restricted_foods text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

-- Fitness goals
CREATE TABLE IF NOT EXISTS fitness_goals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  description text DEFAULT '',
  target_calories_adjustment integer DEFAULT 0,
  recommended_macros jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);

-- User profiles
CREATE TABLE IF NOT EXISTS user_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  daily_calorie_target integer,
  daily_water_target float,
  activity_level text DEFAULT 'moderate' CHECK (activity_level IN ('sedentary', 'light', 'moderate', 'very', 'extra')),
  preferred_meal_times jsonb DEFAULT '{}',
  favorite_cuisines jsonb DEFAULT '[]',
  disliked_ingredients jsonb DEFAULT '[]',
  onboarding_completed boolean DEFAULT false,
  onboarding_completed_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id)
);

-- User profile health conditions junction table
CREATE TABLE IF NOT EXISTS user_profile_health_conditions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_profile_id uuid REFERENCES user_profiles(id) ON DELETE CASCADE,
  health_condition_id uuid REFERENCES health_conditions(id) ON DELETE CASCADE,
  UNIQUE(user_profile_id, health_condition_id)
);

-- User profile allergies junction table
CREATE TABLE IF NOT EXISTS user_profile_allergies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_profile_id uuid REFERENCES user_profiles(id) ON DELETE CASCADE,
  allergy_id uuid REFERENCES allergies(id) ON DELETE CASCADE,
  UNIQUE(user_profile_id, allergy_id)
);

-- User profile dietary preferences junction table
CREATE TABLE IF NOT EXISTS user_profile_dietary_preferences (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_profile_id uuid REFERENCES user_profiles(id) ON DELETE CASCADE,
  dietary_preference_id uuid REFERENCES dietary_preferences(id) ON DELETE CASCADE,
  UNIQUE(user_profile_id, dietary_preference_id)
);

-- User profile fitness goals junction table
CREATE TABLE IF NOT EXISTS user_profile_fitness_goals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_profile_id uuid REFERENCES user_profiles(id) ON DELETE CASCADE,
  fitness_goal_id uuid REFERENCES fitness_goals(id) ON DELETE CASCADE,
  UNIQUE(user_profile_id, fitness_goal_id)
);

-- Achievements
CREATE TABLE IF NOT EXISTS achievements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text NOT NULL,
  icon text DEFAULT '🏆',
  category text CHECK (category IN ('cooking', 'planning', 'health', 'cultural', 'social')),
  points integer DEFAULT 10,
  requirements jsonb DEFAULT '{}',
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- User achievements
CREATE TABLE IF NOT EXISTS user_achievements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  achievement_id uuid REFERENCES achievements(id) ON DELETE CASCADE,
  earned_at timestamptz DEFAULT now(),
  progress jsonb DEFAULT '{}',
  UNIQUE(user_id, achievement_id)
);

-- Regions
CREATE TABLE IF NOT EXISTS regions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  description text DEFAULT '',
  countries jsonb DEFAULT '[]',
  cultural_notes text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

-- Cuisines
CREATE TABLE IF NOT EXISTS cuisines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  region_id uuid REFERENCES regions(id) ON DELETE CASCADE,
  description text DEFAULT '',
  characteristics jsonb DEFAULT '[]',
  created_at timestamptz DEFAULT now(),
  UNIQUE(name, region_id)
);

-- Ingredients
CREATE TABLE IF NOT EXISTS ingredients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  local_names jsonb DEFAULT '[]',
  category text CHECK (category IN ('vegetables', 'fruits', 'grains', 'legumes', 'meat', 'fish', 'dairy', 'spices', 'oils', 'nuts', 'other')),
  description text DEFAULT '',
  nutritional_info jsonb DEFAULT '{}',
  seasonality jsonb DEFAULT '[]',
  storage_tips text DEFAULT '',
  allergen_info jsonb DEFAULT '[]',
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Ingredient regions junction table
CREATE TABLE IF NOT EXISTS ingredient_regions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingredient_id uuid REFERENCES ingredients(id) ON DELETE CASCADE,
  region_id uuid REFERENCES regions(id) ON DELETE CASCADE,
  UNIQUE(ingredient_id, region_id)
);

-- Ingredient substitutes junction table
CREATE TABLE IF NOT EXISTS ingredient_substitutes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingredient_id uuid REFERENCES ingredients(id) ON DELETE CASCADE,
  substitute_id uuid REFERENCES ingredients(id) ON DELETE CASCADE,
  UNIQUE(ingredient_id, substitute_id)
);

-- Recipes
CREATE TABLE IF NOT EXISTS recipes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text NOT NULL,
  cuisine_id uuid REFERENCES cuisines(id) ON DELETE CASCADE,
  prep_time integer NOT NULL CHECK (prep_time > 0),
  cook_time integer NOT NULL CHECK (cook_time > 0),
  total_time integer NOT NULL CHECK (total_time > 0),
  servings integer DEFAULT 4 CHECK (servings > 0),
  difficulty text CHECK (difficulty IN ('easy', 'medium', 'hard')),
  meal_type text CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'dessert', 'beverage')),
  ingredients jsonb NOT NULL DEFAULT '[]',
  instructions jsonb NOT NULL DEFAULT '[]',
  calories_per_serving integer CHECK (calories_per_serving > 0),
  nutritional_info jsonb DEFAULT '{}',
  image text,
  video_url text,
  cultural_significance text DEFAULT '',
  origin_story text DEFAULT '',
  traditional_occasions jsonb DEFAULT '[]',
  tags jsonb DEFAULT '[]',
  dietary_labels jsonb DEFAULT '[]',
  allergen_warnings jsonb DEFAULT '[]',
  created_by uuid REFERENCES users(id) ON DELETE SET NULL,
  chef_notes text DEFAULT '',
  is_published boolean DEFAULT true,
  is_featured boolean DEFAULT false,
  average_rating float DEFAULT 0.0 CHECK (average_rating >= 0 AND average_rating <= 5),
  total_ratings integer DEFAULT 0 CHECK (total_ratings >= 0),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Recipe ratings
CREATE TABLE IF NOT EXISTS recipe_ratings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id uuid REFERENCES recipes(id) ON DELETE CASCADE,
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(recipe_id, user_id)
);

-- User recipes
CREATE TABLE IF NOT EXISTS user_recipes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  recipe_id uuid REFERENCES recipes(id) ON DELETE CASCADE,
  status text DEFAULT 'saved' CHECK (status IN ('saved', 'planned', 'cooking', 'completed')),
  is_favorite boolean DEFAULT false,
  times_cooked integer DEFAULT 0 CHECK (times_cooked >= 0),
  last_cooked timestamptz,
  personal_notes text DEFAULT '',
  modifications jsonb DEFAULT '[]',
  cooking_started_at timestamptz,
  cooking_completed_at timestamptz,
  cooking_duration integer CHECK (cooking_duration > 0),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id, recipe_id)
);

-- Recipe collections
CREATE TABLE IF NOT EXISTS recipe_collections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  is_public boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id, name)
);

-- Recipe collection recipes junction table
CREATE TABLE IF NOT EXISTS recipe_collection_recipes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  collection_id uuid REFERENCES recipe_collections(id) ON DELETE CASCADE,
  recipe_id uuid REFERENCES recipes(id) ON DELETE CASCADE,
  UNIQUE(collection_id, recipe_id)
);

-- Cooking tips
CREATE TABLE IF NOT EXISTS cooking_tips (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  content text NOT NULL,
  category text CHECK (category IN ('technique', 'ingredient', 'equipment', 'safety', 'cultural', 'nutrition')),
  is_featured boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Cooking tip recipes junction table
CREATE TABLE IF NOT EXISTS cooking_tip_recipes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tip_id uuid REFERENCES cooking_tips(id) ON DELETE CASCADE,
  recipe_id uuid REFERENCES recipes(id) ON DELETE CASCADE,
  UNIQUE(tip_id, recipe_id)
);

-- Cooking tip ingredients junction table
CREATE TABLE IF NOT EXISTS cooking_tip_ingredients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tip_id uuid REFERENCES cooking_tips(id) ON DELETE CASCADE,
  ingredient_id uuid REFERENCES ingredients(id) ON DELETE CASCADE,
  UNIQUE(tip_id, ingredient_id)
);

-- Meal plans
CREATE TABLE IF NOT EXISTS meal_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  name text DEFAULT 'My Meal Plan',
  start_date date NOT NULL,
  end_date date NOT NULL,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Meal plan entries
CREATE TABLE IF NOT EXISTS meal_plan_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  meal_plan_id uuid REFERENCES meal_plans(id) ON DELETE CASCADE,
  recipe_id uuid REFERENCES recipes(id) ON DELETE CASCADE,
  date date NOT NULL,
  meal_type text CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
  servings integer DEFAULT 1 CHECK (servings > 0),
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  UNIQUE(meal_plan_id, date, meal_type)
);

-- Shopping lists
CREATE TABLE IF NOT EXISTS shopping_lists (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  name text NOT NULL,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Shopping list items
CREATE TABLE IF NOT EXISTS shopping_list_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  shopping_list_id uuid REFERENCES shopping_lists(id) ON DELETE CASCADE,
  name text NOT NULL,
  quantity text NOT NULL,
  category text DEFAULT '',
  is_purchased boolean DEFAULT false,
  estimated_price decimal(10,2),
  created_at timestamptz DEFAULT now()
);

-- AI recommendations
CREATE TABLE IF NOT EXISTS ai_recommendations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  recommendation_type text CHECK (recommendation_type IN ('meal_plan', 'recipe', 'ingredient_substitute', 'cooking_tip', 'cultural_insight')),
  content jsonb NOT NULL DEFAULT '{}',
  confidence_score float DEFAULT 0.0 CHECK (confidence_score >= 0 AND confidence_score <= 1),
  user_context jsonb DEFAULT '{}',
  user_rating integer CHECK (user_rating >= 1 AND user_rating <= 5),
  user_feedback text DEFAULT '',
  was_helpful boolean,
  created_at timestamptz DEFAULT now(),
  viewed_at timestamptz,
  acted_upon_at timestamptz
);

-- User preference profiles (AI)
CREATE TABLE IF NOT EXISTS user_preference_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  preferred_flavors jsonb DEFAULT '[]',
  preferred_cooking_methods jsonb DEFAULT '[]',
  preferred_meal_times jsonb DEFAULT '{}',
  ingredient_preferences jsonb DEFAULT '{}',
  cuisine_preferences jsonb DEFAULT '{}',
  cooking_frequency jsonb DEFAULT '{}',
  recipe_complexity_preference float DEFAULT 0.5 CHECK (recipe_complexity_preference >= 0 AND recipe_complexity_preference <= 1),
  seasonal_preferences jsonb DEFAULT '{}',
  nutrition_priorities jsonb DEFAULT '[]',
  portion_preferences jsonb DEFAULT '{}',
  cultural_openness_score float DEFAULT 0.5 CHECK (cultural_openness_score >= 0 AND cultural_openness_score <= 1),
  traditional_vs_modern_preference float DEFAULT 0.5 CHECK (traditional_vs_modern_preference >= 0 AND traditional_vs_modern_preference <= 1),
  last_updated timestamptz DEFAULT now(),
  confidence_score float DEFAULT 0.0 CHECK (confidence_score >= 0 AND confidence_score <= 1),
  UNIQUE(user_id)
);

-- AI interactions
CREATE TABLE IF NOT EXISTS ai_interactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  interaction_type text CHECK (interaction_type IN ('recommendation_request', 'recipe_search', 'meal_plan_generation', 'ingredient_substitution', 'cooking_assistance', 'cultural_query')),
  user_input jsonb NOT NULL DEFAULT '{}',
  context_data jsonb DEFAULT '{}',
  ai_model_used text DEFAULT 'gpt-4',
  processing_time_ms integer,
  tokens_used integer,
  ai_response jsonb NOT NULL DEFAULT '{}',
  confidence_score float DEFAULT 0.0 CHECK (confidence_score >= 0 AND confidence_score <= 1),
  user_satisfaction integer CHECK (user_satisfaction >= 1 AND user_satisfaction <= 5),
  user_followed_suggestion boolean,
  created_at timestamptz DEFAULT now()
);

-- Cultural insights
CREATE TABLE IF NOT EXISTS cultural_insights (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id uuid REFERENCES recipes(id) ON DELETE CASCADE,
  ingredient_id uuid REFERENCES ingredients(id) ON DELETE CASCADE,
  cuisine_id uuid REFERENCES cuisines(id) ON DELETE CASCADE,
  title text NOT NULL,
  content text NOT NULL,
  cultural_context jsonb DEFAULT '{}',
  generated_by_ai boolean DEFAULT true,
  ai_confidence float DEFAULT 0.0 CHECK (ai_confidence >= 0 AND ai_confidence <= 1),
  verified_by_expert boolean DEFAULT false,
  view_count integer DEFAULT 0 CHECK (view_count >= 0),
  helpful_votes integer DEFAULT 0 CHECK (helpful_votes >= 0),
  not_helpful_votes integer DEFAULT 0 CHECK (not_helpful_votes >= 0),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_cooking_level ON users(cooking_level);
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_recipes_cuisine_id ON recipes(cuisine_id);
CREATE INDEX IF NOT EXISTS idx_recipes_difficulty ON recipes(difficulty);
CREATE INDEX IF NOT EXISTS idx_recipes_meal_type ON recipes(meal_type);
CREATE INDEX IF NOT EXISTS idx_recipes_average_rating ON recipes(average_rating);
CREATE INDEX IF NOT EXISTS idx_recipes_is_published ON recipes(is_published);
CREATE INDEX IF NOT EXISTS idx_recipes_is_featured ON recipes(is_featured);
CREATE INDEX IF NOT EXISTS idx_recipe_ratings_recipe_id ON recipe_ratings(recipe_id);
CREATE INDEX IF NOT EXISTS idx_recipe_ratings_user_id ON recipe_ratings(user_id);
CREATE INDEX IF NOT EXISTS idx_user_recipes_user_id ON user_recipes(user_id);
CREATE INDEX IF NOT EXISTS idx_user_recipes_status ON user_recipes(status);
CREATE INDEX IF NOT EXISTS idx_meal_plans_user_id ON meal_plans(user_id);
CREATE INDEX IF NOT EXISTS idx_meal_plan_entries_meal_plan_id ON meal_plan_entries(meal_plan_id);
CREATE INDEX IF NOT EXISTS idx_shopping_lists_user_id ON shopping_lists(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_recommendations_user_id ON ai_recommendations(user_id);

-- Full-text search indexes
CREATE INDEX IF NOT EXISTS idx_recipes_search ON recipes USING gin(to_tsvector('english', name || ' ' || description));
CREATE INDEX IF NOT EXISTS idx_ingredients_search ON ingredients USING gin(to_tsvector('english', name || ' ' || description));

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_plan_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE shopping_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE shopping_list_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preference_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_interactions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

-- RLS Policies for user_profiles
CREATE POLICY "Users can view own user profile" ON user_profiles
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for user_achievements
CREATE POLICY "Users can view own achievements" ON user_achievements
  FOR SELECT USING (auth.uid() = user_id);

-- RLS Policies for recipe_ratings
CREATE POLICY "Users can manage own ratings" ON recipe_ratings
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Anyone can view ratings" ON recipe_ratings
  FOR SELECT USING (true);

-- RLS Policies for user_recipes
CREATE POLICY "Users can manage own recipe interactions" ON user_recipes
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for recipe_collections
CREATE POLICY "Users can manage own collections" ON recipe_collections
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Anyone can view public collections" ON recipe_collections
  FOR SELECT USING (is_public = true);

-- RLS Policies for meal_plans
CREATE POLICY "Users can manage own meal plans" ON meal_plans
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for meal_plan_entries
CREATE POLICY "Users can manage own meal plan entries" ON meal_plan_entries
  FOR ALL USING (auth.uid() IN (SELECT user_id FROM meal_plans WHERE id = meal_plan_id));

-- RLS Policies for shopping_lists
CREATE POLICY "Users can manage own shopping lists" ON shopping_lists
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for shopping_list_items
CREATE POLICY "Users can manage own shopping list items" ON shopping_list_items
  FOR ALL USING (auth.uid() IN (SELECT user_id FROM shopping_lists WHERE id = shopping_list_id));

-- RLS Policies for AI recommendations
CREATE POLICY "Users can view own AI recommendations" ON ai_recommendations
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for user_preference_profiles
CREATE POLICY "Users can manage own AI profiles" ON user_preference_profiles
  FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for ai_interactions
CREATE POLICY "Users can view own AI interactions" ON ai_interactions
  FOR ALL USING (auth.uid() = user_id);

-- Public read access for reference data
CREATE POLICY "Anyone can view health conditions" ON health_conditions FOR SELECT USING (true);
CREATE POLICY "Anyone can view allergies" ON allergies FOR SELECT USING (true);
CREATE POLICY "Anyone can view dietary preferences" ON dietary_preferences FOR SELECT USING (true);
CREATE POLICY "Anyone can view fitness goals" ON fitness_goals FOR SELECT USING (true);
CREATE POLICY "Anyone can view achievements" ON achievements FOR SELECT USING (true);
CREATE POLICY "Anyone can view regions" ON regions FOR SELECT USING (true);
CREATE POLICY "Anyone can view cuisines" ON cuisines FOR SELECT USING (true);
CREATE POLICY "Anyone can view ingredients" ON ingredients FOR SELECT USING (true);
CREATE POLICY "Anyone can view published recipes" ON recipes FOR SELECT USING (is_published = true);
CREATE POLICY "Anyone can view cooking tips" ON cooking_tips FOR SELECT USING (true);
CREATE POLICY "Anyone can view cultural insights" ON cultural_insights FOR SELECT USING (true);

-- Functions and triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Add update triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_recipes_updated_at BEFORE UPDATE ON recipes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_recipe_ratings_updated_at BEFORE UPDATE ON recipe_ratings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_recipes_updated_at BEFORE UPDATE ON user_recipes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_recipe_collections_updated_at BEFORE UPDATE ON recipe_collections FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_meal_plans_updated_at BEFORE UPDATE ON meal_plans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_shopping_lists_updated_at BEFORE UPDATE ON shopping_lists FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cultural_insights_updated_at BEFORE UPDATE ON cultural_insights FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update recipe ratings
CREATE OR REPLACE FUNCTION update_recipe_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE recipes
  SET 
    average_rating = COALESCE((
      SELECT AVG(rating)::float
      FROM recipe_ratings
      WHERE recipe_id = COALESCE(NEW.recipe_id, OLD.recipe_id)
    ), 0),
    total_ratings = COALESCE((
      SELECT COUNT(*)::integer
      FROM recipe_ratings
      WHERE recipe_id = COALESCE(NEW.recipe_id, OLD.recipe_id)
    ), 0),
    updated_at = now()
  WHERE id = COALESCE(NEW.recipe_id, OLD.recipe_id);
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update recipe ratings
CREATE TRIGGER recipe_rating_trigger
  AFTER INSERT OR UPDATE OR DELETE ON recipe_ratings
  FOR EACH ROW EXECUTE FUNCTION update_recipe_rating();

-- Function to automatically create user profile
CREATE OR REPLACE FUNCTION create_user_profile()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO user_profiles (user_id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to create user profile
CREATE TRIGGER create_user_profile_trigger
  AFTER INSERT ON users
  FOR EACH ROW EXECUTE FUNCTION create_user_profile();