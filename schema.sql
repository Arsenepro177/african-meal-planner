-- African Meal Planner Database Schema
-- Created: 2025-07-21
-- Description: PostgreSQL schema for African Meal Planner application

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users and Authentication
CREATE TABLE auth_user (
    id SERIAL PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    last_login TIMESTAMP WITH TIME ZONE,
    is_superuser BOOLEAN NOT NULL,
    username VARCHAR(150) NOT NULL UNIQUE,
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    is_staff BOOLEAN NOT NULL,
    is_active BOOLEAN NOT NULL,
    date_joined TIMESTAMP WITH TIME ZONE NOT NULL,
    phone_number VARCHAR(20),
    date_of_birth DATE,
    gender CHAR(1),
    height FLOAT,
    weight FLOAT,
    country VARCHAR(100),
    city VARCHAR(100),
    location VARCHAR(200),
    cooking_level VARCHAR(20),
    profile_picture VARCHAR(100),
    email_verified BOOLEAN DEFAULT FALSE,
    last_activity TIMESTAMP WITH TIME ZONE,
    timezone VARCHAR(50)
);

-- Health Conditions
CREATE TABLE accounts_healthcondition (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    dietary_restrictions TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Allergies
CREATE TABLE accounts_allergy (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    severity_level VARCHAR(20) NOT NULL,
    common_foods TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Dietary Preferences
CREATE TABLE accounts_dietarypreference (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    allowed_foods TEXT,
    restricted_foods TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Fitness Goals
CREATE TABLE accounts_fitnessgoal (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    target_calories_adjustment INTEGER NOT NULL,
    recommended_macros JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- User Profiles
CREATE TABLE accounts_userprofile (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    daily_calorie_target INTEGER,
    daily_water_target FLOAT,
    activity_level VARCHAR(20) NOT NULL,
    preferred_meal_times JSONB,
    favorite_cuisines JSONB,
    disliked_ingredients JSONB,
    onboarding_completed BOOLEAN NOT NULL DEFAULT FALSE,
    onboarding_completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Many-to-Many: UserProfile to HealthCondition
CREATE TABLE accounts_userprofile_health_conditions (
    id SERIAL PRIMARY KEY,
    userprofile_id INTEGER NOT NULL REFERENCES accounts_userprofile(id) ON DELETE CASCADE,
    healthcondition_id INTEGER NOT NULL REFERENCES accounts_healthcondition(id) ON DELETE CASCADE,
    UNIQUE(userprofile_id, healthcondition_id)
);

-- Many-to-Many: UserProfile to Allergy
CREATE TABLE accounts_userprofile_allergies (
    id SERIAL PRIMARY KEY,
    userprofile_id INTEGER NOT NULL REFERENCES accounts_userprofile(id) ON DELETE CASCADE,
    allergy_id INTEGER NOT NULL REFERENCES accounts_allergy(id) ON DELETE CASCADE,
    UNIQUE(userprofile_id, allergy_id)
);

-- Many-to-Many: UserProfile to DietaryPreference
CREATE TABLE accounts_userprofile_dietary_preferences (
    id SERIAL PRIMARY KEY,
    userprofile_id INTEGER NOT NULL REFERENCES accounts_userprofile(id) ON DELETE CASCADE,
    dietarypreference_id INTEGER NOT NULL REFERENCES accounts_dietarypreference(id) ON DELETE CASCADE,
    UNIQUE(userprofile_id, dietarypreference_id)
);

-- Many-to-Many: UserProfile to FitnessGoal
CREATE TABLE accounts_userprofile_fitness_goals (
    id SERIAL PRIMARY KEY,
    userprofile_id INTEGER NOT NULL REFERENCES accounts_userprofile(id) ON DELETE CASCADE,
    fitnessgoal_id INTEGER NOT NULL REFERENCES accounts_fitnessgoal(id) ON DELETE CASCADE,
    UNIQUE(userprofile_id, fitnessgoal_id)
);

-- Achievements
CREATE TABLE accounts_achievement (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    icon VARCHAR(10) NOT NULL,
    category VARCHAR(50) NOT NULL,
    points INTEGER NOT NULL,
    requirements JSONB,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- User Achievements
CREATE TABLE accounts_userachievement (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    achievement_id INTEGER NOT NULL REFERENCES accounts_achievement(id) ON DELETE CASCADE,
    earned_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    progress JSONB,
    UNIQUE(user_id, achievement_id)
);

-- Regions
CREATE TABLE recipes_region (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    countries JSONB,
    cultural_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Cuisines
CREATE TABLE recipes_cuisine (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region_id INTEGER NOT NULL REFERENCES recipes_region(id) ON DELETE CASCADE,
    description TEXT,
    characteristics JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(name, region_id)
);

-- Ingredients
CREATE TABLE recipes_ingredient (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) UNIQUE NOT NULL,
    local_names JSONB,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    nutritional_info JSONB,
    seasonality JSONB,
    storage_tips TEXT,
    allergen_info JSONB,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Many-to-Many: Ingredient to Region
CREATE TABLE recipes_ingredient_common_regions (
    id SERIAL PRIMARY KEY,
    ingredient_id INTEGER NOT NULL REFERENCES recipes_ingredient(id) ON DELETE CASCADE,
    region_id INTEGER NOT NULL REFERENCES recipes_region(id) ON DELETE CASCADE,
    UNIQUE(ingredient_id, region_id)
);

-- Many-to-Many: Ingredient to Ingredient (substitutes)
CREATE TABLE recipes_ingredient_substitutes (
    id SERIAL PRIMARY KEY,
    from_ingredient_id INTEGER NOT NULL REFERENCES recipes_ingredient(id) ON DELETE CASCADE,
    to_ingredient_id INTEGER NOT NULL REFERENCES recipes_ingredient(id) ON DELETE CASCADE,
    UNIQUE(from_ingredient_id, to_ingredient_id)
);

-- Recipes
CREATE TABLE recipes_recipe (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(250) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    cuisine_id INTEGER NOT NULL REFERENCES recipes_cuisine(id) ON DELETE CASCADE,
    prep_time INTEGER NOT NULL,
    cook_time INTEGER NOT NULL,
    total_time INTEGER NOT NULL,
    servings INTEGER NOT NULL,
    difficulty VARCHAR(10) NOT NULL,
    meal_type VARCHAR(20) NOT NULL,
    ingredients JSONB NOT NULL,
    instructions JSONB NOT NULL,
    calories_per_serving INTEGER,
    nutritional_info JSONB,
    image VARCHAR(100),
    video_url VARCHAR(200),
    cultural_significance TEXT,
    origin_story TEXT,
    traditional_occasions JSONB,
    tags JSONB,
    dietary_labels JSONB,
    allergen_warnings JSONB,
    created_by_id INTEGER REFERENCES auth_user(id) ON DELETE SET NULL,
    chef_notes TEXT,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    average_rating DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    total_ratings INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Recipe Ratings
CREATE TABLE recipes_reciperating (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER NOT NULL REFERENCES recipes_recipe(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(recipe_id, user_id)
);

-- User Recipes
CREATE TABLE recipes_userrecipe (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    recipe_id INTEGER NOT NULL REFERENCES recipes_recipe(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL,
    is_favorite BOOLEAN NOT NULL DEFAULT FALSE,
    times_cooked INTEGER NOT NULL DEFAULT 0,
    last_cooked TIMESTAMP WITH TIME ZONE,
    personal_notes TEXT,
    modifications JSONB,
    cooking_started_at TIMESTAMP WITH TIME ZONE,
    cooking_completed_at TIMESTAMP WITH TIME ZONE,
    cooking_duration INTEGER,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, recipe_id)
);

-- Recipe Collections
CREATE TABLE recipes_recipecollection (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    user_id INTEGER NOT NULL REFERENCES auth_user(id) ON DELETE CASCADE,
    is_public BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Many-to-Many: RecipeCollection to Recipe
CREATE TABLE recipes_recipecollection_recipes (
    id SERIAL PRIMARY KEY,
    recipecollection_id INTEGER NOT NULL REFERENCES recipes_recipecollection(id) ON DELETE CASCADE,
    recipe_id INTEGER NOT NULL REFERENCES recipes_recipe(id) ON DELETE CASCADE,
    UNIQUE(recipecollection_id, recipe_id)
);

-- Cooking Tips
CREATE TABLE recipes_cookingtip (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Many-to-Many: CookingTip to Recipe
CREATE TABLE recipes_cookingtip_related_recipes (
    id SERIAL PRIMARY KEY,
    cookingtip_id INTEGER NOT NULL REFERENCES recipes_cookingtip(id) ON DELETE CASCADE,
    recipe_id INTEGER NOT NULL REFERENCES recipes_recipe(id) ON DELETE CASCADE,
    UNIQUE(cookingtip_id, recipe_id)
);

-- Many-to-Many: CookingTip to Ingredient
CREATE TABLE recipes_cookingtip_related_ingredients (
    id SERIAL PRIMARY KEY,
    cookingtip_id INTEGER NOT NULL REFERENCES recipes_cookingtip(id) ON DELETE CASCADE,
    ingredient_id INTEGER NOT NULL REFERENCES recipes_ingredient(id) ON DELETE CASCADE,
    UNIQUE(cookingtip_id, ingredient_id)
);

-- Indexes for better query performance
CREATE INDEX idx_recipe_cuisine ON recipes_recipe(cuisine_id);
CREATE INDEX idx_recipe_created_by ON recipes_recipe(created_by_id);
CREATE INDEX idx_recipe_rating ON recipes_recipe(average_rating);
CREATE INDEX idx_recipe_meal_type ON recipes_recipe(meal_type);
CREATE INDEX idx_recipe_difficulty ON recipes_recipe(difficulty);
CREATE INDEX idx_ingredient_category ON recipes_ingredient(category);
CREATE INDEX idx_user_recipe_status ON recipes_userrecipe(user_id, status);
CREATE INDEX idx_recipe_collection_user ON recipes_recipecollection(user_id);
CREATE INDEX idx_recipe_rating_user ON recipes_reciperating(user_id);
CREATE INDEX idx_recipe_rating_recipe ON recipes_reciperating(recipe_id);

-- Add a function to update recipe ratings
CREATE OR REPLACE FUNCTION update_recipe_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE recipes_recipe
    SET 
        average_rating = (
            SELECT AVG(rating)
            FROM recipes_reciperating
            WHERE recipe_id = COALESCE(NEW.recipe_id, OLD.recipe_id)
        ),
        total_ratings = (
            SELECT COUNT(*)
            FROM recipes_reciperating
            WHERE recipe_id = COALESCE(NEW.recipe_id, OLD.recipe_id)
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = COALESCE(NEW.recipe_id, OLD.recipe_id);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create triggers to update recipe ratings
CREATE TRIGGER recipe_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON recipes_reciperating
FOR EACH ROW EXECUTE FUNCTION update_recipe_rating();

-- Add a function to update timestamps
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers to update timestamps
CREATE TRIGGER update_accounts_userprofile_timestamp
BEFORE UPDATE ON accounts_userprofile
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_recipes_recipe_timestamp
BEFORE UPDATE ON recipes_recipe
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_recipes_reciperating_timestamp
BEFORE UPDATE ON recipes_reciperating
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_recipes_userrecipe_timestamp
BEFORE UPDATE ON recipes_userrecipe
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_recipes_recipecollection_timestamp
BEFORE UPDATE ON recipes_recipecollection
FOR EACH ROW EXECUTE FUNCTION update_timestamp();
