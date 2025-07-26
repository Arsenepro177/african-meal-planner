import 'react-native-url-polyfill/auto'
import { createClient } from '@supabase/supabase-js'
import AsyncStorage from '@react-native-async-storage/async-storage'

// Supabase configuration
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL || ''
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY || ''

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn('Supabase URL or Anon Key is missing. Please check your environment variables.')
}

// Create Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: AsyncStorage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
})

// Database types (you can generate these from Supabase CLI)
export type Database = {
  public: {
    Tables: {
      auth_user: {
        Row: {
          id: number
          username: string
          email: string
          first_name: string
          last_name: string
          is_active: boolean
          date_joined: string
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
          created_at: string
          updated_at: string
          last_active: string
        }
        Insert: {
          username: string
          email: string
          first_name?: string
          last_name?: string
          is_active?: boolean
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
        }
        Update: {
          username?: string
          email?: string
          first_name?: string
          last_name?: string
          is_active?: boolean
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
  // Sign up
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

  // Sign in
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
    const { data, error } = await supabase.auth.resetPasswordForEmail(email)
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

// Storage helper functions
export const storageService = {
  // Upload file
  uploadFile: async (bucket: string, path: string, file: File | Blob) => {
    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(path, file)
    return { data, error }
  },

  // Download file
  downloadFile: async (bucket: string, path: string) => {
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
  deleteFile: async (bucket: string, paths: string[]) => {
    const { data, error } = await supabase.storage
      .from(bucket)
      .remove(paths)
    return { data, error }
  },
}

export default supabase
