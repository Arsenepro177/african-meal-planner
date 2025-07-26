import 'react-native-url-polyfill/auto'
import { createClient } from '@supabase/supabase-js'
import AsyncStorage from '@react-native-async-storage/async-storage'

// Supabase configuration
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL || ''
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY || ''

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn('Supabase URL or Anon Key is missing. Please check your environment variables.')
}

// Create Supabase client with proper configuration
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: AsyncStorage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
  global: {
    headers: {
      'X-Client-Info': 'african-meal-planner@1.0.0',
    },
  },
})

// Database types
export type Database = {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          username: string
          first_name: string
          last_name: string
          phone_number: string | null
          date_of_birth: string | null
          gender: string | null
          height: number | null
          weight: number | null
          country: string | null
          city: string | null
          location: string | null
          cooking_level: string
          family_size: number
          bio: string | null
          avatar: string | null
          notifications_enabled: boolean
          location_enabled: boolean
          offline_mode: boolean
          is_active: boolean
          created_at: string
          updated_at: string
          last_active: string
        }
        Insert: {
          id?: string
          email: string
          username: string
          first_name?: string
          last_name?: string
          phone_number?: string | null
          date_of_birth?: string | null
          gender?: string | null
          height?: number | null
          weight?: number | null
          country?: string | null
          city?: string | null
          location?: string | null
          cooking_level?: string
          family_size?: number
          bio?: string | null
          avatar?: string | null
          notifications_enabled?: boolean
          location_enabled?: boolean
          offline_mode?: boolean
          is_active?: boolean
        }
        Update: {
          email?: string
          username?: string
          first_name?: string
          last_name?: string
          phone_number?: string | null
          date_of_birth?: string | null
          gender?: string | null
          height?: number | null
          weight?: number | null
          country?: string | null
          city?: string | null
          location?: string | null
          cooking_level?: string
          family_size?: number
          bio?: string | null
          avatar?: string | null
          notifications_enabled?: boolean
          location_enabled?: boolean
          offline_mode?: boolean
          is_active?: boolean
          updated_at?: string
          last_active?: string
        }
      }
      user_profiles: {
        Row: {
          id: string
          user_id: string
          daily_calorie_target: number | null
          daily_water_target: number | null
          activity_level: string
          preferred_meal_times: any
          favorite_cuisines: any
          disliked_ingredients: any
          onboarding_completed: boolean
          onboarding_completed_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          daily_calorie_target?: number | null
          daily_water_target?: number | null
          activity_level?: string
          preferred_meal_times?: any
          favorite_cuisines?: any
          disliked_ingredients?: any
          onboarding_completed?: boolean
          onboarding_completed_at?: string | null
        }
        Update: {
          daily_calorie_target?: number | null
          daily_water_target?: number | null
          activity_level?: string
          preferred_meal_times?: any
          favorite_cuisines?: any
          disliked_ingredients?: any
          onboarding_completed?: boolean
          onboarding_completed_at?: string | null
          updated_at?: string
        }
      }
      recipes: {
        Row: {
          id: string
          name: string
          slug: string
          description: string
          cuisine_id: string
          prep_time: number
          cook_time: number
          total_time: number
          servings: number
          difficulty: string
          meal_type: string
          ingredients: any
          instructions: any
          calories_per_serving: number | null
          nutritional_info: any
          image: string | null
          video_url: string | null
          cultural_significance: string
          origin_story: string
          traditional_occasions: any
          tags: any
          dietary_labels: any
          allergen_warnings: any
          created_by: string | null
          chef_notes: string
          is_published: boolean
          is_featured: boolean
          average_rating: number
          total_ratings: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          slug: string
          description: string
          cuisine_id: string
          prep_time: number
          cook_time: number
          total_time: number
          servings?: number
          difficulty: string
          meal_type: string
          ingredients: any
          instructions: any
          calories_per_serving?: number | null
          nutritional_info?: any
          image?: string | null
          video_url?: string | null
          cultural_significance?: string
          origin_story?: string
          traditional_occasions?: any
          tags?: any
          dietary_labels?: any
          allergen_warnings?: any
          created_by?: string | null
          chef_notes?: string
          is_published?: boolean
          is_featured?: boolean
          average_rating?: number
          total_ratings?: number
        }
        Update: {
          name?: string
          slug?: string
          description?: string
          cuisine_id?: string
          prep_time?: number
          cook_time?: number
          total_time?: number
          servings?: number
          difficulty?: string
          meal_type?: string
          ingredients?: any
          instructions?: any
          calories_per_serving?: number | null
          nutritional_info?: any
          image?: string | null
          video_url?: string | null
          cultural_significance?: string
          origin_story?: string
          traditional_occasions?: any
          tags?: any
          dietary_labels?: any
          allergen_warnings?: any
          chef_notes?: string
          is_published?: boolean
          is_featured?: boolean
          updated_at?: string
        }
      }
      // Add other table types as needed
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}

// Authentication helper functions
export const authService = {
  // Sign up with email and password
  signUp: async (email: string, password: string, userData?: any) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: userData,
      },
    })
    return { data, error }
  },

  // Sign in with email and password
  signIn: async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })
    return { data, error }
  },

  // Sign out
  signOut: async () => {
    const { error } = await supabase.auth.signOut()
    return { error }
  },

  // Get current user
  getCurrentUser: async () => {
    const { data: { user }, error } = await supabase.auth.getUser()
    return { user, error }
  },

  // Get current session
  getSession: async () => {
    const { data: { session }, error } = await supabase.auth.getSession()
    return { session, error }
  },

  // Reset password
  resetPassword: async (email: string) => {
    const { data, error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: 'africanmealplanner://reset-password',
    })
    return { data, error }
  },

  // Update password
  updatePassword: async (password: string) => {
    const { data, error } = await supabase.auth.updateUser({
      password,
    })
    return { data, error }
  },

  // Update user metadata
  updateUserMetadata: async (metadata: any) => {
    const { data, error } = await supabase.auth.updateUser({
      data: metadata,
    })
    return { data, error }
  },
}

// Database helper functions
export const dbService = {
  // Users
  async createUser(userData: Database['public']['Tables']['users']['Insert']) {
    const { data, error } = await supabase
      .from('users')
      .insert(userData)
      .select()
      .single()
    return { data, error }
  },

  async getUser(userId: string) {
    const { data, error } = await supabase
      .from('users')
      .select(`
        *,
        user_profiles (*)
      `)
      .eq('id', userId)
      .single()
    return { data, error }
  },

  async updateUser(userId: string, updates: Database['public']['Tables']['users']['Update']) {
    const { data, error } = await supabase
      .from('users')
      .update(updates)
      .eq('id', userId)
      .select()
      .single()
    return { data, error }
  },

  // User Profiles
  async updateUserProfile(userId: string, profileData: Database['public']['Tables']['user_profiles']['Update']) {
    const { data, error } = await supabase
      .from('user_profiles')
      .update(profileData)
      .eq('user_id', userId)
      .select()
      .single()
    return { data, error }
  },

  // Recipes
  async getRecipes(filters?: any) {
    let query = supabase
      .from('recipes')
      .select(`
        *,
        cuisines (
          name,
          regions (name)
        )
      `)
      .eq('is_published', true)

    if (filters?.cuisine_id) {
      query = query.eq('cuisine_id', filters.cuisine_id)
    }
    if (filters?.difficulty) {
      query = query.eq('difficulty', filters.difficulty)
    }
    if (filters?.meal_type) {
      query = query.eq('meal_type', filters.meal_type)
    }
    if (filters?.max_prep_time) {
      query = query.lte('prep_time', filters.max_prep_time)
    }

    const { data, error } = await query.order('created_at', { ascending: false })
    return { data, error }
  },

  async getRecipe(slug: string) {
    const { data, error } = await supabase
      .from('recipes')
      .select(`
        *,
        cuisines (
          name,
          regions (name)
        )
      `)
      .eq('slug', slug)
      .eq('is_published', true)
      .single()
    return { data, error }
  },

  async getFeaturedRecipes() {
    const { data, error } = await supabase
      .from('recipes')
      .select(`
        *,
        cuisines (
          name,
          regions (name)
        )
      `)
      .eq('is_published', true)
      .eq('is_featured', true)
      .order('average_rating', { ascending: false })
      .limit(10)
    return { data, error }
  },

  // Reference Data
  async getRegions() {
    const { data, error } = await supabase
      .from('regions')
      .select('*')
      .order('name')
    return { data, error }
  },

  async getCuisines() {
    const { data, error } = await supabase
      .from('cuisines')
      .select(`
        *,
        regions (name)
      `)
      .order('name')
    return { data, error }
  },

  async getIngredients() {
    const { data, error } = await supabase
      .from('ingredients')
      .select('*')
      .eq('is_active', true)
      .order('category', { ascending: true })
      .order('name', { ascending: true })
    return { data, error }
  },

  async getHealthConditions() {
    const { data, error } = await supabase
      .from('health_conditions')
      .select('*')
      .order('name')
    return { data, error }
  },

  async getAllergies() {
    const { data, error } = await supabase
      .from('allergies')
      .select('*')
      .order('name')
    return { data, error }
  },

  async getDietaryPreferences() {
    const { data, error } = await supabase
      .from('dietary_preferences')
      .select('*')
      .order('name')
    return { data, error }
  },

  async getFitnessGoals() {
    const { data, error } = await supabase
      .from('fitness_goals')
      .select('*')
      .order('name')
    return { data, error }
  },
}

// Storage helper functions
export const storageService = {
  // Upload file
  async uploadFile(bucket: string, path: string, file: File | Blob) {
    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(path, file, {
        cacheControl: '3600',
        upsert: false
      })
    return { data, error }
  },

  // Download file
  async downloadFile(bucket: string, path: string) {
    const { data, error } = await supabase.storage
      .from(bucket)
      .download(path)
    return { data, error }
  },

  // Get public URL
  getPublicUrl: (bucket: string, path: string) => {
    return supabase.storage
      .from(bucket)
      .getPublicUrl(path)
  },

  // Delete file
  async deleteFile(bucket: string, paths: string[]) {
    const { data, error } = await supabase.storage
      .from(bucket)
      .remove(paths)
    return { data, error }
  },

  // List files
  async listFiles(bucket: string, folder?: string) {
    const { data, error } = await supabase.storage
      .from(bucket)
      .list(folder, {
        limit: 100,
        offset: 0,
      })
    return { data, error }
  },
}

export default supabase