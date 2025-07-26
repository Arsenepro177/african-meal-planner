/*
  # Seed Data for African Meal Planner

  1. Reference Data
    - Health conditions
    - Allergies
    - Dietary preferences
    - Fitness goals
    - Achievements
    - African regions
    - Cuisines
    - Common ingredients

  2. Sample Data
    - Sample recipes
    - Cooking tips
*/

-- Insert health conditions
INSERT INTO health_conditions (name, description, dietary_restrictions) VALUES
('Diabetes', 'Type 1 or Type 2 diabetes requiring blood sugar management', 'Low sugar, controlled carbohydrates'),
('Hypertension', 'High blood pressure requiring sodium restriction', 'Low sodium, DASH diet'),
('Heart Disease', 'Cardiovascular conditions requiring heart-healthy diet', 'Low saturated fat, low cholesterol'),
('High Cholesterol', 'Elevated cholesterol levels', 'Low cholesterol, high fiber'),
('Kidney Disease', 'Chronic kidney disease requiring protein and mineral restriction', 'Low protein, low phosphorus, low potassium'),
('Liver Disease', 'Liver conditions requiring dietary modifications', 'Low fat, limited protein'),
('Thyroid Issues', 'Hyperthyroidism or hypothyroidism', 'Iodine considerations'),
('Celiac Disease', 'Gluten intolerance requiring strict gluten-free diet', 'Gluten-free'),
('Lactose Intolerance', 'Inability to digest lactose', 'Dairy-free or lactase enzyme'),
('None', 'No known health conditions', '')
ON CONFLICT (name) DO NOTHING;

-- Insert allergies
INSERT INTO allergies (name, description, severity_level, common_foods) VALUES
('Peanuts', 'Peanut allergy', 'severe', 'Peanuts, peanut oil, peanut butter'),
('Tree Nuts', 'Tree nut allergies', 'severe', 'Almonds, walnuts, cashews, pecans'),
('Shellfish', 'Shellfish allergy', 'severe', 'Shrimp, crab, lobster, oysters'),
('Fish', 'Fish allergy', 'moderate', 'All fish varieties'),
('Eggs', 'Egg allergy', 'moderate', 'Chicken eggs, egg products'),
('Dairy', 'Milk protein allergy', 'moderate', 'Milk, cheese, yogurt, butter'),
('Soy', 'Soy allergy', 'mild', 'Soybeans, soy sauce, tofu'),
('Wheat', 'Wheat allergy', 'moderate', 'Wheat flour, bread, pasta'),
('Sesame', 'Sesame seed allergy', 'moderate', 'Sesame seeds, tahini, sesame oil'),
('Sulfites', 'Sulfite sensitivity', 'mild', 'Wine, dried fruits, processed foods'),
('None', 'No known allergies', 'mild', '')
ON CONFLICT (name) DO NOTHING;

-- Insert dietary preferences
INSERT INTO dietary_preferences (name, description, allowed_foods, restricted_foods) VALUES
('Vegetarian', 'Plant-based diet excluding meat and fish', 'Vegetables, fruits, grains, legumes, dairy, eggs', 'Meat, poultry, fish, seafood'),
('Vegan', 'Plant-based diet excluding all animal products', 'Vegetables, fruits, grains, legumes, nuts, seeds', 'All animal products'),
('Pescatarian', 'Vegetarian diet that includes fish and seafood', 'Vegetables, fruits, grains, legumes, fish, seafood, dairy, eggs', 'Meat, poultry'),
('Halal', 'Islamic dietary laws', 'Halal-certified foods', 'Pork, alcohol, non-halal meat'),
('Kosher', 'Jewish dietary laws', 'Kosher-certified foods', 'Non-kosher foods, mixing meat and dairy'),
('Paleo', 'Paleolithic diet focusing on whole foods', 'Meat, fish, vegetables, fruits, nuts, seeds', 'Grains, legumes, dairy, processed foods'),
('Keto', 'High-fat, low-carbohydrate diet', 'High-fat foods, low-carb vegetables, meat, fish', 'Grains, sugar, high-carb foods'),
('Low Carb', 'Reduced carbohydrate intake', 'Protein, healthy fats, low-carb vegetables', 'Grains, sugar, starchy vegetables'),
('Mediterranean', 'Mediterranean-style eating pattern', 'Olive oil, fish, vegetables, fruits, whole grains', 'Processed foods, excessive red meat'),
('Gluten-Free', 'Avoiding gluten-containing foods', 'Gluten-free grains, vegetables, fruits, meat, fish', 'Wheat, barley, rye, gluten-containing foods'),
('No Restrictions', 'No specific dietary restrictions', 'All foods', '')
ON CONFLICT (name) DO NOTHING;

-- Insert fitness goals
INSERT INTO fitness_goals (name, description, target_calories_adjustment, recommended_macros) VALUES
('Weight Loss', 'Lose weight through caloric deficit', -300, '{"protein": 30, "carbs": 40, "fat": 30}'),
('Weight Gain', 'Gain weight through caloric surplus', 300, '{"protein": 25, "carbs": 45, "fat": 30}'),
('Muscle Building', 'Build lean muscle mass', 200, '{"protein": 35, "carbs": 40, "fat": 25}'),
('Heart Health', 'Improve cardiovascular health', 0, '{"protein": 20, "carbs": 50, "fat": 30}'),
('Diabetes Management', 'Manage blood sugar levels', 0, '{"protein": 25, "carbs": 45, "fat": 30}'),
('General Wellness', 'Maintain overall health', 0, '{"protein": 25, "carbs": 45, "fat": 30}'),
('Athletic Performance', 'Optimize performance for athletes', 400, '{"protein": 25, "carbs": 55, "fat": 20}'),
('Digestive Health', 'Improve digestive function', 0, '{"protein": 20, "carbs": 50, "fat": 30}')
ON CONFLICT (name) DO NOTHING;

-- Insert achievements
INSERT INTO achievements (name, description, icon, category, points, requirements) VALUES
('First Recipe', 'Cooked your first recipe', '🍳', 'cooking', 10, '{"recipes_cooked": 1}'),
('Recipe Explorer', 'Tried 10 different recipes', '🗺️', 'cooking', 25, '{"recipes_cooked": 10}'),
('Master Chef', 'Successfully completed 50 recipes', '👨‍🍳', 'cooking', 100, '{"recipes_cooked": 50}'),
('Cultural Ambassador', 'Cooked dishes from 4 African regions', '🌍', 'cultural', 50, '{"regions_explored": 4}'),
('Meal Planner', 'Created your first meal plan', '📅', 'planning', 15, '{"meal_plans_created": 1}'),
('Planning Pro', 'Planned meals for 30 consecutive days', '📊', 'planning', 75, '{"consecutive_planning_days": 30}'),
('Health Conscious', 'Tracked nutrition for 7 days', '💚', 'health', 20, '{"nutrition_tracking_days": 7}'),
('Social Cook', 'Shared 5 recipes with friends', '👥', 'social', 30, '{"recipes_shared": 5}'),
('Spice Master', 'Used 20 different African spices', '🌶️', 'cultural', 40, '{"spices_used": 20}'),
('Tradition Keeper', 'Learned 10 cultural food stories', '📚', 'cultural', 35, '{"cultural_stories_read": 10}')
ON CONFLICT (name) DO NOTHING;

-- Insert African regions
INSERT INTO regions (name, description, countries, cultural_notes) VALUES
('West Africa', 'Rich culinary traditions with bold flavors and communal dining', 
 '["Nigeria", "Ghana", "Senegal", "Mali", "Burkina Faso", "Ivory Coast", "Guinea", "Sierra Leone", "Liberia", "Benin", "Togo", "Niger", "Gambia", "Guinea-Bissau", "Cape Verde", "Mauritania"]',
 'Known for jollof rice, fufu, and extensive use of palm oil and hot peppers'),
('East Africa', 'Diverse cuisine influenced by Arab, Indian, and indigenous traditions',
 '["Ethiopia", "Kenya", "Tanzania", "Uganda", "Rwanda", "Burundi", "Somalia", "Eritrea", "Djibouti", "South Sudan"]',
 'Famous for injera, berbere spice, and coffee culture'),
('North Africa', 'Mediterranean and Middle Eastern influences with aromatic spices',
 '["Morocco", "Algeria", "Tunisia", "Libya", "Egypt", "Sudan"]',
 'Known for tagines, couscous, and preserved lemons'),
('Southern Africa', 'Fusion of indigenous, Dutch, and Indian culinary traditions',
 '["South Africa", "Zimbabwe", "Botswana", "Namibia", "Zambia", "Malawi", "Lesotho", "Swaziland", "Mozambique", "Angola"]',
 'Famous for braai culture, biltong, and diverse meat preparations'),
('Central Africa', 'Forest-based cuisine with cassava, plantains, and bushmeat',
 '["Democratic Republic of Congo", "Central African Republic", "Cameroon", "Chad", "Republic of Congo", "Equatorial Guinea", "Gabon", "São Tomé and Príncipe"]',
 'Rich in starchy staples and forest vegetables')
ON CONFLICT (name) DO NOTHING;

-- Insert cuisines
INSERT INTO cuisines (name, region_id, description, characteristics) VALUES
('Nigerian', (SELECT id FROM regions WHERE name = 'West Africa'), 'Bold, spicy flavors with rice and yam staples', '["Spicy", "Rice-based", "Palm oil", "Peppers"]'),
('Ghanaian', (SELECT id FROM regions WHERE name = 'West Africa'), 'Hearty stews and grilled meats with plantains', '["Stews", "Grilled meats", "Plantains", "Groundnuts"]'),
('Senegalese', (SELECT id FROM regions WHERE name = 'West Africa'), 'Fish-based dishes with rice and vegetables', '["Fish", "Rice", "Vegetables", "Thieboudienne"]'),
('Ethiopian', (SELECT id FROM regions WHERE name = 'East Africa'), 'Spicy stews served on injera bread', '["Injera", "Berbere spice", "Stews", "Coffee"]'),
('Kenyan', (SELECT id FROM regions WHERE name = 'East Africa'), 'Simple, hearty meals with ugali and vegetables', '["Ugali", "Vegetables", "Grilled meats", "Tea"]'),
('Moroccan', (SELECT id FROM regions WHERE name = 'North Africa'), 'Aromatic tagines and couscous dishes', '["Tagines", "Couscous", "Preserved lemons", "Ras el hanout"]'),
('Egyptian', (SELECT id FROM regions WHERE name = 'North Africa'), 'Ancient cuisine with beans, bread, and vegetables', '["Ful medames", "Bread", "Vegetables", "Legumes"]'),
('South African', (SELECT id FROM regions WHERE name = 'Southern Africa'), 'Diverse fusion cuisine with braai culture', '["Braai", "Biltong", "Boerewors", "Potjiekos"]'),
('Zimbabwean', (SELECT id FROM regions WHERE name = 'Southern Africa'), 'Sadza-based meals with vegetables and meat', '["Sadza", "Vegetables", "Meat", "Traditional beer"]'),
('Congolese', (SELECT id FROM regions WHERE name = 'Central Africa'), 'Cassava-based dishes with forest vegetables', '["Cassava", "Plantains", "Forest vegetables", "Fish"]')
ON CONFLICT (name, region_id) DO NOTHING;

-- Insert common ingredients
INSERT INTO ingredients (name, local_names, category, description, nutritional_info, seasonality, storage_tips, allergen_info) VALUES
('Cassava', '["Manioc", "Yuca", "Tapioca"]', 'grains', 'Starchy root vegetable, staple food in many African countries', '{"calories": 160, "carbs": 38, "protein": 1.4, "fat": 0.3}', '["Year-round"]', 'Store in cool, dry place. Use within 2-3 days of peeling.', '[]'),
('Plantain', '["Cooking banana", "Matooke"]', 'fruits', 'Large banana variety used for cooking, can be green or ripe', '{"calories": 122, "carbs": 32, "protein": 1.3, "fat": 0.4}', '["Year-round"]', 'Store at room temperature. Green plantains can be refrigerated.', '[]'),
('Yam', '["Igname", "Ñame"]', 'grains', 'Starchy tuber, different from sweet potato', '{"calories": 118, "carbs": 28, "protein": 1.5, "fat": 0.2}', '["October", "November", "December"]', 'Store in cool, dark, well-ventilated place.', '[]'),
('Palm Oil', '["Red palm oil", "Dende oil"]', 'oils', 'Red oil extracted from palm fruit, rich in vitamin A', '{"calories": 884, "fat": 100, "vitamin_a": "high"}', '["Year-round"]', 'Store in cool place. Solidifies at room temperature.', '[]'),
('Scotch Bonnet Pepper', '["Bonney pepper", "Caribbean red pepper"]', 'spices', 'Very hot chili pepper, essential in West African cuisine', '{"calories": 40, "vitamin_c": "very_high", "capsaicin": "high"}', '["Year-round"]', 'Store in refrigerator. Handle with gloves.', '[]'),
('Berbere', '["Ethiopian spice blend"]', 'spices', 'Complex Ethiopian spice blend with chili peppers', '{"calories": 282, "protein": 11, "fiber": 34}', '["Year-round"]', 'Store in airtight container away from light.', '[]'),
('Injera', '["Ethiopian flatbread", "Teff bread"]', 'grains', 'Spongy sourdough flatbread made from teff flour', '{"calories": 85, "carbs": 18, "protein": 3, "fiber": 2}', '["Year-round"]', 'Best consumed fresh. Can be stored wrapped for 2-3 days.', '[]'),
('Okra', '["Lady fingers", "Bamia"]', 'vegetables', 'Green pod vegetable, natural thickener for stews', '{"calories": 33, "carbs": 7, "protein": 2, "fiber": 3}', '["Summer", "Fall"]', 'Store in refrigerator. Use within 3-4 days.', '[]'),
('Baobab Fruit', '["Monkey bread fruit", "Cream of tartar tree fruit"]', 'fruits', 'Superfruit with tangy flavor, high in vitamin C', '{"calories": 162, "vitamin_c": "very_high", "fiber": 10}', '["Dry season"]', 'Powder form stores well in airtight container.', '[]'),
('Millet', '["Pearl millet", "Finger millet"]', 'grains', 'Ancient grain, gluten-free, drought-resistant', '{"calories": 378, "carbs": 73, "protein": 11, "fiber": 8}', '["Dry season"]', 'Store in airtight container in cool, dry place.', '[]'),
('Groundnuts', '["Peanuts", "Monkey nuts"]', 'nuts', 'Protein-rich legume, used for sauces and snacks', '{"calories": 567, "protein": 26, "fat": 49, "fiber": 8}', '["Dry season"]', 'Store in cool, dry place. Check for mold regularly.', '["Peanuts"]'),
('Cowpeas', '["Black-eyed peas", "Niebe"]', 'legumes', 'Protein-rich legume, staple in West African cuisine', '{"calories": 336, "protein": 24, "carbs": 60, "fiber": 11}', '["Rainy season"]', 'Store dried beans in airtight container.', '[]'),
('Moringa', '["Drumstick tree leaves", "Miracle tree"]', 'vegetables', 'Nutrient-dense leaves, superfood', '{"calories": 64, "protein": 9, "vitamin_a": "very_high", "iron": "high"}', '["Year-round"]', 'Use fresh leaves immediately or dry for powder.', '[]'),
('Tamarind', '["Indian date", "Tamarin"]', 'fruits', 'Tangy fruit used for flavoring and sauces', '{"calories": 239, "carbs": 63, "fiber": 5, "vitamin_c": "moderate"}', '["Dry season"]', 'Store pods in cool, dry place. Paste keeps refrigerated.', '[]'),
('Hibiscus', '["Sorrel", "Zobo leaves"]', 'spices', 'Dried flowers used for tea and flavoring', '{"calories": 37, "vitamin_c": "high", "antioxidants": "very_high"}', '["Year-round"]', 'Store dried flowers in airtight container.', '[]')
ON CONFLICT (name) DO NOTHING;

-- Insert sample recipes
INSERT INTO recipes (name, slug, description, cuisine_id, prep_time, cook_time, total_time, servings, difficulty, meal_type, ingredients, instructions, calories_per_serving, cultural_significance, tags, dietary_labels) VALUES
('Jollof Rice', 'jollof-rice', 'The beloved West African one-pot rice dish with tomatoes, spices, and your choice of protein', 
 (SELECT id FROM cuisines WHERE name = 'Nigerian'), 20, 45, 65, 6, 'medium', 'lunch',
 '[{"name": "Jasmine rice", "quantity": "2 cups"}, {"name": "Tomatoes", "quantity": "4 large"}, {"name": "Onions", "quantity": "2 medium"}, {"name": "Red bell pepper", "quantity": "1"}, {"name": "Scotch bonnet pepper", "quantity": "1"}, {"name": "Tomato paste", "quantity": "3 tbsp"}, {"name": "Chicken stock", "quantity": "3 cups"}, {"name": "Bay leaves", "quantity": "2"}, {"name": "Curry powder", "quantity": "1 tsp"}, {"name": "Thyme", "quantity": "1 tsp"}, {"name": "Salt", "quantity": "to taste"}, {"name": "Vegetable oil", "quantity": "3 tbsp"}]',
 '[{"step": 1, "description": "Blend tomatoes, onions, and red bell pepper until smooth"}, {"step": 2, "description": "Heat oil in a large pot and fry tomato paste for 2 minutes"}, {"step": 3, "description": "Add blended tomato mixture and cook for 15 minutes until reduced"}, {"step": 4, "description": "Add rice, stock, and seasonings. Bring to boil"}, {"step": 5, "description": "Reduce heat, cover and simmer for 25 minutes"}, {"step": 6, "description": "Let rest for 5 minutes before serving"}]',
 420, 'Jollof rice is more than just a dish - it represents unity and celebration across West Africa. Each country has its own variation, leading to friendly debates about the best version.',
 '["rice", "one-pot", "west-african", "celebration", "family-meal"]', '["gluten-free", "dairy-free"]'),

('Injera with Doro Wat', 'injera-doro-wat', 'Traditional Ethiopian sourdough flatbread served with spicy chicken stew',
 (SELECT id FROM cuisines WHERE name = 'Ethiopian'), 30, 180, 210, 8, 'hard', 'dinner',
 '[{"name": "Teff flour", "quantity": "2 cups"}, {"name": "Water", "quantity": "3 cups"}, {"name": "Whole chicken", "quantity": "1"}, {"name": "Red onions", "quantity": "4 large"}, {"name": "Berbere spice", "quantity": "4 tbsp"}, {"name": "Hard-boiled eggs", "quantity": "6"}, {"name": "Niter kibbeh", "quantity": "1/4 cup"}, {"name": "Garlic", "quantity": "6 cloves"}, {"name": "Ginger", "quantity": "2 inch piece"}]',
 '[{"step": 1, "description": "Mix teff flour with water and let ferment for 3 days"}, {"step": 2, "description": "Cook injera batter on mitad or non-stick pan until bubbly"}, {"step": 3, "description": "Sauté onions until golden and caramelized"}, {"step": 4, "description": "Add berbere spice and cook for 2 minutes"}, {"step": 5, "description": "Add chicken pieces and brown on all sides"}, {"step": 6, "description": "Add water and simmer for 1 hour"}, {"step": 7, "description": "Add hard-boiled eggs and simmer 30 more minutes"}, {"step": 8, "description": "Serve hot with injera"}]',
 520, 'Doro Wat is Ethiopia\'s national dish, traditionally served during special occasions and holidays. The berbere spice blend is the soul of Ethiopian cuisine.',
 '["traditional", "fermented", "spicy", "cultural", "celebration"]', '["gluten-free", "dairy-free"]'),

('Moroccan Tagine', 'moroccan-tagine', 'Slow-cooked stew with tender meat, vegetables, and aromatic North African spices',
 (SELECT id FROM cuisines WHERE name = 'Moroccan'), 25, 120, 145, 6, 'medium', 'dinner',
 '[{"name": "Lamb shoulder", "quantity": "2 lbs"}, {"name": "Onions", "quantity": "2 large"}, {"name": "Dried apricots", "quantity": "1 cup"}, {"name": "Ras el hanout", "quantity": "2 tsp"}, {"name": "Cinnamon stick", "quantity": "1"}, {"name": "Almonds", "quantity": "1/2 cup"}, {"name": "Fresh cilantro", "quantity": "1/4 cup"}, {"name": "Preserved lemons", "quantity": "2"}, {"name": "Olive oil", "quantity": "3 tbsp"}, {"name": "Chicken stock", "quantity": "2 cups"}]',
 '[{"step": 1, "description": "Brown lamb pieces in tagine or heavy pot"}, {"step": 2, "description": "Add onions and cook until softened"}, {"step": 3, "description": "Add ras el hanout and cinnamon, cook for 1 minute"}, {"step": 4, "description": "Add stock and bring to simmer"}, {"step": 5, "description": "Cover and cook for 1.5 hours until meat is tender"}, {"step": 6, "description": "Add apricots and almonds, cook 15 more minutes"}, {"step": 7, "description": "Garnish with cilantro and preserved lemons"}]',
 380, 'Tagine cooking represents the heart of Moroccan hospitality. The conical lid creates a unique steam circulation that keeps food moist and flavorful.',
 '["slow-cooked", "aromatic", "dried-fruits", "traditional", "north-african"]', '["dairy-free", "gluten-free"])

ON CONFLICT (slug) DO NOTHING;

-- Insert cooking tips
INSERT INTO cooking_tips (title, content, category, is_featured) VALUES
('Perfect Jollof Rice Every Time', 'The secret to perfect jollof rice is in the tomato base. Cook your tomato mixture until it''s thick and the oil starts to separate. This concentrates the flavors and gives the rice its characteristic taste.', 'technique', true),
('Working with Scotch Bonnet Peppers', 'Always wear gloves when handling scotch bonnet peppers. To reduce heat while keeping flavor, remove the seeds and white membrane. For maximum heat, include everything!', 'ingredient', true),
('Fermenting Injera Properly', 'True injera requires 3-5 days of fermentation. The batter should smell slightly sour and have bubbles. If you''re short on time, add a bit of sourdough starter to speed up the process.', 'technique', false),
('Using Palm Oil Correctly', 'Palm oil should be heated until it becomes clear (bleached) for most dishes. This removes the raw taste. However, for some traditional dishes, the red color is desired.', 'ingredient', true),
('Tagine Cooking Without a Tagine', 'Don''t have a tagine pot? Use a heavy-bottomed pot with a tight-fitting lid. Place a sheet of parchment paper under the lid to create a better seal and mimic the tagine''s steam circulation.', 'equipment', false)
ON CONFLICT DO NOTHING;