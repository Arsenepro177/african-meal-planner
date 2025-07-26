import React, { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import { initializeDatabase } from '@/lib/database';
import { supabase } from '@/lib/supabase';

interface DatabaseContextType {
  isConnected: boolean;
  isLoading: boolean;
  error: string | null;
  reconnect: () => Promise<void>;
}

const DatabaseContext = createContext<DatabaseContextType | undefined>(undefined);

export const useDatabase = () => {
  const context = useContext(DatabaseContext);
  if (!context) {
    throw new Error('useDatabase must be used within a DatabaseProvider');
  }
  return context;
};

interface DatabaseProviderProps {
  children: ReactNode;
}

export const DatabaseProvider: React.FC<DatabaseProviderProps> = ({ children }) => {
  const [isConnected, setIsConnected] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const checkConnection = async () => {
    try {
      setIsLoading(true);
      setError(null);
      
      const connected = await initializeDatabase();
      setIsConnected(connected);
      
      if (!connected) {
        setError('Failed to connect to database');
      }
    } catch (err) {
      console.error('Database connection error:', err);
      setError(err instanceof Error ? err.message : 'Database connection failed');
      setIsConnected(false);
    } finally {
      setIsLoading(false);
    }
  };

  const reconnect = async () => {
    await checkConnection();
  };

  useEffect(() => {
    checkConnection();

    // Listen for auth state changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        if (event === 'SIGNED_IN') {
          console.log('User signed in, checking database connection');
          await checkConnection();
        } else if (event === 'SIGNED_OUT') {
          console.log('User signed out');
          setIsConnected(false);
        }
      }
    );

    return () => {
      subscription.unsubscribe();
    };
  }, []);

  const value: DatabaseContextType = {
    isConnected,
    isLoading,
    error,
    reconnect,
  };

  return (
    <DatabaseContext.Provider value={value}>
      {children}
    </DatabaseContext.Provider>
  );
};