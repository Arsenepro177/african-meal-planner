import React, { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import { authService, supabase } from '@/lib/supabase';
import { userService } from '@/lib/database';

interface User {
  id: string;
  username: string;
  email: string;
  first_name: string;
  last_name: string;
  cooking_level: string;
  family_size: number;
  profile?: {
    onboarding_completed: boolean;
    daily_calorie_target?: number;
    activity_level: string;
  };
}

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (userData: any) => Promise<void>;
  logout: () => Promise<void>;
  updateProfile: (profileData: any) => Promise<void>;
  completeOnboarding: (onboardingData: any) => Promise<void>;
  refreshUser: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const isAuthenticated = !!user;

  // Check for existing token on app start
  useEffect(() => {
    initializeAuth();
  }, []);

  const initializeAuth = async () => {
    try {
      const { session, error } = await authService.getSession();
      if (error) throw error;
      
      if (session?.user) {
        const { data: userData, error: userError } = await userService.getUserProfile(session.user.id);
        if (userError) throw userError;
        
        if (userData) {
          setUser({
            id: userData.id,
            username: userData.username,
            email: userData.email,
            first_name: userData.first_name,
            last_name: userData.last_name,
            cooking_level: userData.cooking_level,
            family_size: userData.family_size,
            profile: userData.user_profiles ? {
              onboarding_completed: userData.user_profiles.onboarding_completed,
              daily_calorie_target: userData.user_profiles.daily_calorie_target,
              activity_level: userData.user_profiles.activity_level,
            } : undefined,
          });
        }
      }
    } catch (error) {
      console.error('Auth check failed:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const login = async (email: string, password: string) => {
    try {
      setIsLoading(true);
      const { data, error } = await authService.signIn(email, password);
      if (error) throw error;
      
      if (data.user) {
        const { data: userData, error: userError } = await userService.getUserProfile(data.user.id);
        if (userError) throw userError;
        
        if (userData) {
          setUser({
            id: userData.id,
            username: userData.username,
            email: userData.email,
            first_name: userData.first_name,
            last_name: userData.last_name,
            cooking_level: userData.cooking_level,
            family_size: userData.family_size,
            profile: userData.user_profiles ? {
              onboarding_completed: userData.user_profiles.onboarding_completed,
              daily_calorie_target: userData.user_profiles.daily_calorie_target,
              activity_level: userData.user_profiles.activity_level,
            } : undefined,
          });
        }
      }
    } catch (error) {
      console.error('Login failed:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const register = async (userData: any) => {
    try {
      setIsLoading(true);
      const { data, error } = await authService.signUp(userData.email, userData.password, {
        first_name: userData.first_name,
        last_name: userData.last_name,
      });
      if (error) throw error;
      
      if (data.user) {
        // Create user profile in database
        const { user: newUser, error: profileError } = await userService.createUserProfile(data.user.id, {
          email: userData.email,
          username: userData.username || userData.email,
          first_name: userData.first_name || '',
          last_name: userData.last_name || '',
        });
        
        if (profileError) throw profileError;
        
        if (newUser) {
          setUser({
            id: newUser.id,
            username: newUser.username,
            email: newUser.email,
            first_name: newUser.first_name,
            last_name: newUser.last_name,
            cooking_level: newUser.cooking_level,
            family_size: newUser.family_size,
            profile: {
              onboarding_completed: false,
              activity_level: 'moderate',
            },
          });
        }
      }
    } catch (error) {
      console.error('Registration failed:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const logout = async () => {
    try {
      await authService.signOut();
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      setUser(null);
    }
  };

  const updateProfile = async (profileData: any) => {
    try {
      if (!user) throw new Error('No user logged in');
      
      const { data, error } = await userService.updateUserProfile(user.id, profileData);
      if (error) throw error;
      
      // Refresh user data
      await refreshUser();
    } catch (error) {
      console.error('Profile update failed:', error);
      throw error;
    }
  };

  const completeOnboarding = async (onboardingData: any) => {
    try {
      if (!user) throw new Error('No user logged in');
      
      const { data, error } = await userService.completeOnboarding(user.id, onboardingData);
      if (error) throw error;
      
      // Refresh user data
      await refreshUser();
    } catch (error) {
      console.error('Onboarding completion failed:', error);
      throw error;
    }
  };

  const refreshUser = async () => {
    try {
      if (!user) return;
      
      const { data: userData, error } = await userService.getUserProfile(user.id);
      if (error) throw error;
      
      if (userData) {
        setUser({
          id: userData.id,
          username: userData.username,
          email: userData.email,
          first_name: userData.first_name,
          last_name: userData.last_name,
          cooking_level: userData.cooking_level,
          family_size: userData.family_size,
          profile: userData.user_profiles ? {
            onboarding_completed: userData.user_profiles.onboarding_completed,
            daily_calorie_target: userData.user_profiles.daily_calorie_target,
            activity_level: userData.user_profiles.activity_level,
          } : undefined,
        });
      }
    } catch (error) {
      console.error('User refresh failed:', error);
      throw error;
    }
  };

  const value: AuthContextType = {
    user,
    isLoading,
    isAuthenticated,
    login,
    register,
    logout,
    updateProfile,
    completeOnboarding,
    refreshUser,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};