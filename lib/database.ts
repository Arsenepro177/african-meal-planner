import { supabase, dbService, Database } from './supabase'

// User management
export const userService = {
  async createUserProfile(userId: string, profileData: any) {
    try {
      // Create user record
      const { data: user, error: userError } = await dbService.createUser({
        id: userId,
        email: profileData.email,
        username: profileData.username || profileData.email,
        first_name: profileData.first_name || '',
        last_name: profileData.last_name || '',
        cooking_level: profileData.cooking_level || 'beginner',
        family_size: profileData.family_size || 1,
      })

      if (userError) throw userError

      return { user, error: null }
    } catch (error) {
      console.error('Error creating user profile:', error)
      return { user: null, error }
    }
  },

  async getUserProfile(userId: string) {
    try {
      const { data, error } = await dbService.getUser(userId)
      return { data, error }
    } catch (error) {
      console.error('Error getting user profile:', error)
      return { data: null, error }
    }
  },

  async updateUserProfile(userId: string, updates: any) {
    try {
      const { data, error } = await dbService.updateUser(userId, updates)
      return { data, error }
    } catch (error) {
      console.error('Error updating user profile:', error)
      return { data: null, error }
    }
  },

  async completeOnboarding(userId: string, onboardingData: any) {
    try {
      // Update user basic info
      const userUpdates: any = {}
      if (onboardingData.height) userUpdates.height = onboardingData.height
      if (onboardingData.weight) userUpdates.weight = onboardingData.weight
      if (onboardingData.gender) userUpdates.gender = onboardingData.gender
      if (onboardingData.cooking_level) userUpdates.cooking_level = onboardingData.cooking_level
      if (onboardingData.family_size) userUpdates.family_size = onboardingData.family_size
      if (onboardingData.location) userUpdates.location = onboardingData.location

      // Calculate date of birth from age
      if (onboardingData.age) {
        const currentYear = new Date().getFullYear()
        const birthYear = currentYear - onboardingData.age
        userUpdates.date_of_birth = `${birthYear}-01-01`
      }

      const { data: userData, error: userError } = await dbService.updateUser(userId, userUpdates)
      if (userError) throw userError

      // Update user profile
      const profileUpdates = {
        activity_level: onboardingData.activity_level || 'moderate',
        onboarding_completed: true,
        onboarding_completed_at: new Date().toISOString(),
      }

      // Calculate daily calorie target (simplified BMR calculation)
      if (onboardingData.height && onboardingData.weight && onboardingData.age && onboardingData.gender) {
        let bmr: number
        if (onboardingData.gender === 'M') {
          bmr = 10 * onboardingData.weight + 6.25 * onboardingData.height - 5 * onboardingData.age + 5
        } else {
          bmr = 10 * onboardingData.weight + 6.25 * onboardingData.height - 5 * onboardingData.age - 161
        }

        const activityMultipliers = {
          sedentary: 1.2,
          light: 1.375,
          moderate: 1.55,
          very: 1.725,
          extra: 1.9,
        }

        const multiplier = activityMultipliers[onboardingData.activity_level as keyof typeof activityMultipliers] || 1.55
        profileUpdates.daily_calorie_target = Math.round(bmr * multiplier)
      }

      const { data: profileData, error: profileError } = await dbService.updateUserProfile(userId, profileUpdates)
      if (profileError) throw profileError

      return { data: { user: userData, profile: profileData }, error: null }
    } catch (error) {
      console.error('Error completing onboarding:', error)
      return { data: null, error }
    }
  },
}

// Recipe management
export const recipeService = {
  async getRecipes(filters?: any) {
    try {
      const { data, error } = await dbService.getRecipes(filters)
      return { data, error }
    } catch (error) {
      console.error('Error getting recipes:', error)
      return { data: null, error }
    }
  },

  async getRecipe(slug: string) {
    try {
      const { data, error } = await dbService.getRecipe(slug)
      return { data, error }
    } catch (error) {
      console.error('Error getting recipe:', error)
      return { data: null, error }
    }
  },

  async getFeaturedRecipes() {
    try {
      const { data, error } = await dbService.getFeaturedRecipes()
      return { data, error }
    } catch (error) {
      console.error('Error getting featured recipes:', error)
      return { data: null, error }
    }
  },

  async searchRecipes(query: string, filters?: any) {
    try {
      let supabaseQuery = supabase
        .from('recipes')
        .select(`
          *,
          cuisines (
            name,
            regions (name)
          )
        `)
        .eq('is_published', true)

      // Add text search
      if (query) {
        supabaseQuery = supabaseQuery.textSearch('name', query)
      }

      // Add filters
      if (filters?.cuisine_id) {
        supabaseQuery = supabaseQuery.eq('cuisine_id', filters.cuisine_id)
      }
      if (filters?.difficulty) {
        supabaseQuery = supabaseQuery.eq('difficulty', filters.difficulty)
      }
      if (filters?.meal_type) {
        supabaseQuery = supabaseQuery.eq('meal_type', filters.meal_type)
      }
      if (filters?.max_prep_time) {
        supabaseQuery = supabaseQuery.lte('prep_time', filters.max_prep_time)
      }

      const { data, error } = await supabaseQuery
        .order('average_rating', { ascending: false })
        .limit(50)

      return { data, error }
    } catch (error) {
      console.error('Error searching recipes:', error)
      return { data: null, error }
    }
  },

  async saveRecipe(userId: string, recipeId: string) {
    try {
      const { data, error } = await supabase
        .from('user_recipes')
        .upsert({
          user_id: userId,
          recipe_id: recipeId,
          status: 'saved',
        })
        .select()
        .single()

      return { data, error }
    } catch (error) {
      console.error('Error saving recipe:', error)
      return { data: null, error }
    }
  },

  async toggleFavorite(userId: string, recipeId: string) {
    try {
      // First check if user recipe exists
      const { data: existing } = await supabase
        .from('user_recipes')
        .select('*')
        .eq('user_id', userId)
        .eq('recipe_id', recipeId)
        .single()

      if (existing) {
        // Toggle favorite status
        const { data, error } = await supabase
          .from('user_recipes')
          .update({ is_favorite: !existing.is_favorite })
          .eq('user_id', userId)
          .eq('recipe_id', recipeId)
          .select()
          .single()
        return { data, error }
      } else {
        // Create new user recipe as favorite
        const { data, error } = await supabase
          .from('user_recipes')
          .insert({
            user_id: userId,
            recipe_id: recipeId,
            is_favorite: true,
            status: 'saved',
          })
          .select()
          .single()
        return { data, error }
      }
    } catch (error) {
      console.error('Error toggling favorite:', error)
      return { data: null, error }
    }
  },

  async rateRecipe(userId: string, recipeId: string, rating: number, review?: string) {
    try {
      const { data, error } = await supabase
        .from('recipe_ratings')
        .upsert({
          user_id: userId,
          recipe_id: recipeId,
          rating,
          review: review || '',
        })
        .select()
        .single()

      return { data, error }
    } catch (error) {
      console.error('Error rating recipe:', error)
      return { data: null, error }
    }
  },
}

// Reference data
export const referenceService = {
  async getRegions() {
    try {
      const { data, error } = await dbService.getRegions()
      return { data, error }
    } catch (error) {
      console.error('Error getting regions:', error)
      return { data: null, error }
    }
  },

  async getCuisines() {
    try {
      const { data, error } = await dbService.getCuisines()
      return { data, error }
    } catch (error) {
      console.error('Error getting cuisines:', error)
      return { data: null, error }
    }
  },

  async getIngredients() {
    try {
      const { data, error } = await dbService.getIngredients()
      return { data, error }
    } catch (error) {
      console.error('Error getting ingredients:', error)
      return { data: null, error }
    }
  },

  async getHealthConditions() {
    try {
      const { data, error } = await dbService.getHealthConditions()
      return { data, error }
    } catch (error) {
      console.error('Error getting health conditions:', error)
      return { data: null, error }
    }
  },

  async getAllergies() {
    try {
      const { data, error } = await dbService.getAllergies()
      return { data, error }
    } catch (error) {
      console.error('Error getting allergies:', error)
      return { data: null, error }
    }
  },

  async getDietaryPreferences() {
    try {
      const { data, error } = await dbService.getDietaryPreferences()
      return { data, error }
    } catch (error) {
      console.error('Error getting dietary preferences:', error)
      return { data: null, error }
    }
  },

  async getFitnessGoals() {
    try {
      const { data, error } = await dbService.getFitnessGoals()
      return { data, error }
    } catch (error) {
      console.error('Error getting fitness goals:', error)
      return { data: null, error }
    }
  },
}

// Meal planning
export const mealPlanService = {
  async createMealPlan(userId: string, planData: any) {
    try {
      const { data, error } = await supabase
        .from('meal_plans')
        .insert({
          user_id: userId,
          name: planData.name || 'My Meal Plan',
          start_date: planData.start_date,
          end_date: planData.end_date,
        })
        .select()
        .single()

      return { data, error }
    } catch (error) {
      console.error('Error creating meal plan:', error)
      return { data: null, error }
    }
  },

  async getUserMealPlans(userId: string) {
    try {
      const { data, error } = await supabase
        .from('meal_plans')
        .select(`
          *,
          meal_plan_entries (
            *,
            recipes (name, image, prep_time, cook_time)
          )
        `)
        .eq('user_id', userId)
        .order('created_at', { ascending: false })

      return { data, error }
    } catch (error) {
      console.error('Error getting meal plans:', error)
      return { data: null, error }
    }
  },

  async addMealPlanEntry(mealPlanId: string, entryData: any) {
    try {
      const { data, error } = await supabase
        .from('meal_plan_entries')
        .insert({
          meal_plan_id: mealPlanId,
          recipe_id: entryData.recipe_id,
          date: entryData.date,
          meal_type: entryData.meal_type,
          servings: entryData.servings || 1,
          notes: entryData.notes || '',
        })
        .select()
        .single()

      return { data, error }
    } catch (error) {
      console.error('Error adding meal plan entry:', error)
      return { data: null, error }
    }
  },
}

// Shopping lists
export const shoppingService = {
  async createShoppingList(userId: string, name: string) {
    try {
      const { data, error } = await supabase
        .from('shopping_lists')
        .insert({
          user_id: userId,
          name,
        })
        .select()
        .single()

      return { data, error }
    } catch (error) {
      console.error('Error creating shopping list:', error)
      return { data: null, error }
    }
  },

  async getUserShoppingLists(userId: string) {
    try {
      const { data, error } = await supabase
        .from('shopping_lists')
        .select(`
          *,
          shopping_list_items (*)
        `)
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('created_at', { ascending: false })

      return { data, error }
    } catch (error) {
      console.error('Error getting shopping lists:', error)
      return { data: null, error }
    }
  },

  async addShoppingListItem(listId: string, itemData: any) {
    try {
      const { data, error } = await supabase
        .from('shopping_list_items')
        .insert({
          shopping_list_id: listId,
          name: itemData.name,
          quantity: itemData.quantity,
          category: itemData.category || '',
          estimated_price: itemData.estimated_price,
        })
        .select()
        .single()

      return { data, error }
    } catch (error) {
      console.error('Error adding shopping list item:', error)
      return { data: null, error }
    }
  },

  async updateShoppingListItem(itemId: string, updates: any) {
    try {
      const { data, error } = await supabase
        .from('shopping_list_items')
        .update(updates)
        .eq('id', itemId)
        .select()
        .single()

      return { data, error }
    } catch (error) {
      console.error('Error updating shopping list item:', error)
      return { data: null, error }
    }
  },
}

// Initialize database connection
export const initializeDatabase = async () => {
  try {
    // Test connection
    const { data, error } = await supabase
      .from('regions')
      .select('count')
      .limit(1)

    if (error) {
      console.error('Database connection failed:', error)
      return false
    }

    console.log('✅ Database connection successful')
    return true
  } catch (error) {
    console.error('Database initialization error:', error)
    return false
  }
}

export {
  userService,
  recipeService,
  referenceService,
  mealPlanService,
  shoppingService,
}