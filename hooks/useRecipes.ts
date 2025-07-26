import { useState, useEffect } from 'react';
import { recipeService } from '@/lib/database';
import { useAuth } from '@/contexts/AuthContext';

export interface Recipe {
  id: string;
  name: string;
  slug: string;
  description: string;
  cuisine: {
    name: string;
    region: {
      name: string;
    };
  };
  prep_time: number;
  cook_time: number;
  total_time: number;
  servings: number;
  difficulty: string;
  meal_type: string;
  calories_per_serving?: number;
  image?: string;
  average_rating: number;
  total_ratings: number;
  is_featured: boolean;
  ingredients?: any[];
  instructions?: any[];
  cultural_significance?: string;
  tags: string[];
  dietary_labels: string[];
}

export const useRecipes = () => {
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchRecipes = async (params?: any) => {
    try {
      setLoading(true);
      setError(null);
      const { data, error: recipeError } = await recipeService.getRecipes(params);
      if (recipeError) throw recipeError;
      setRecipes(data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch recipes');
    } finally {
      setLoading(false);
    }
  };

  const fetchFeaturedRecipes = async () => {
    try {
      setLoading(true);
      setError(null);
      const { data, error: recipeError } = await recipeService.getFeaturedRecipes();
      if (recipeError) throw recipeError;
      setRecipes(data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch featured recipes');
    } finally {
      setLoading(false);
    }
  };

  const searchRecipes = async (searchData: any) => {
    try {
      setLoading(true);
      setError(null);
      const { data, error: recipeError } = await recipeService.searchRecipes(searchData.query, searchData);
      if (recipeError) throw recipeError;
      setRecipes(data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to search recipes');
    } finally {
      setLoading(false);
    }
  };

  return {
    recipes,
    loading,
    error,
    fetchRecipes,
    fetchFeaturedRecipes,
    searchRecipes,
  };
};

export const useRecipe = (slug: string) => {
  const [recipe, setRecipe] = useState<Recipe | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const { user } = useAuth();

  useEffect(() => {
    if (slug) {
      fetchRecipe();
    }
  }, [slug]);

  const fetchRecipe = async () => {
    try {
      setLoading(true);
      setError(null);
      const { data, error: recipeError } = await recipeService.getRecipe(slug);
      if (recipeError) throw recipeError;
      setRecipe(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch recipe');
    } finally {
      setLoading(false);
    }
  };

  const saveRecipe = async () => {
    if (!recipe || !user) return;
    try {
      await recipeService.saveRecipe(user.id, recipe.id);
    } catch (err) {
      console.error('Failed to save recipe:', err);
    }
  };

  const toggleFavorite = async () => {
    if (!recipe || !user) return;
    try {
      await recipeService.toggleFavorite(user.id, recipe.id);
    } catch (err) {
      console.error('Failed to toggle favorite:', err);
    }
  };

  const rateRecipe = async (rating: number, review?: string) => {
    if (!recipe || !user) return;
    try {
      await recipeService.rateRecipe(user.id, recipe.id, rating, review);
      // Refresh recipe to get updated rating
      await fetchRecipe();
    } catch (err) {
      console.error('Failed to rate recipe:', err);
    }
  };

  return {
    recipe,
    loading,
    error,
    saveRecipe,
    toggleFavorite,
    rateRecipe,
    refetch: fetchRecipe,
  };
};

export const useUserRecipes = () => {
  const [userRecipes, setUserRecipes] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const { user } = useAuth();

  const fetchUserRecipes = async (filters?: any) => {
    if (!user) return;
    try {
      setLoading(true);
      setError(null);
      // This would need to be implemented in the database service
      // const { data, error: userRecipeError } = await userRecipeService.getUserRecipes(user.id, filters);
      // if (userRecipeError) throw userRecipeError;
      // setUserRecipes(data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch user recipes');
    } finally {
      setLoading(false);
    }
  };

  const updateUserRecipe = async (recipeId: number, data: any) => {
    if (!user) return;
    try {
      // This would need to be implemented in the database service
      // Refresh user recipes
      await fetchUserRecipes();
    } catch (err) {
      console.error('Failed to update user recipe:', err);
    }
  };

  return {
    userRecipes,
    loading,
    error,
    fetchUserRecipes,
    updateUserRecipe,
  };
};

export const useRecommendations = () => {
  const [recommendations, setRecommendations] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchRecommendations = async (params?: any) => {
    try {
      setLoading(true);
      setError(null);
      // This would use AI service or simple recommendation logic
      const { data, error: recipeError } = await recipeService.getRecipes(params);
      if (recipeError) throw recipeError;
      setRecommendations(data?.slice(0, 10) || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch recommendations');
    } finally {
      setLoading(false);
    }
  };

  return {
    recommendations,
    loading,
    error,
    fetchRecommendations,
  };
};