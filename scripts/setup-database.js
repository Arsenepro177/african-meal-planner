#!/usr/bin/env node

/**
 * Database Setup Script for African Meal Planner
 * 
 * This script helps set up the Supabase database with proper schema and seed data.
 * Run this after setting up your Supabase project.
 */

const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Configuration
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing Supabase configuration');
  console.error('Please ensure EXPO_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are set in your .env file');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function runMigration(migrationFile) {
  try {
    console.log(`📄 Running migration: ${migrationFile}`);
    
    const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', migrationFile);
    const sql = fs.readFileSync(migrationPath, 'utf8');
    
    // Split SQL into individual statements
    const statements = sql
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0 && !stmt.startsWith('--'));
    
    for (const statement of statements) {
      if (statement.trim()) {
        const { error } = await supabase.rpc('exec_sql', { sql: statement + ';' });
        if (error) {
          console.error(`❌ Error executing statement: ${statement.substring(0, 100)}...`);
          console.error(error);
          return false;
        }
      }
    }
    
    console.log(`✅ Migration completed: ${migrationFile}`);
    return true;
  } catch (error) {
    console.error(`❌ Migration failed: ${migrationFile}`);
    console.error(error);
    return false;
  }
}

async function testConnection() {
  try {
    console.log('🔍 Testing database connection...');
    
    const { data, error } = await supabase
      .from('users')
      .select('count')
      .limit(1);
    
    if (error && !error.message.includes('relation "users" does not exist')) {
      throw error;
    }
    
    console.log('✅ Database connection successful');
    return true;
  } catch (error) {
    console.error('❌ Database connection failed:', error.message);
    return false;
  }
}

async function checkTablesExist() {
  try {
    console.log('🔍 Checking if tables exist...');
    
    const { data, error } = await supabase
      .from('users')
      .select('count')
      .limit(1);
    
    if (error) {
      if (error.message.includes('relation "users" does not exist')) {
        console.log('📋 Tables do not exist, will create them');
        return false;
      }
      throw error;
    }
    
    console.log('✅ Tables already exist');
    return true;
  } catch (error) {
    console.error('❌ Error checking tables:', error.message);
    return false;
  }
}

async function setupDatabase() {
  console.log('🚀 Setting up African Meal Planner database...');
  console.log(`📡 Supabase URL: ${supabaseUrl}`);
  
  // Test connection
  const connected = await testConnection();
  if (!connected) {
    console.error('❌ Cannot proceed without database connection');
    process.exit(1);
  }
  
  // Check if tables already exist
  const tablesExist = await checkTablesExist();
  
  if (!tablesExist) {
    console.log('📋 Creating database schema...');
    
    // Run migrations
    const migrationFiles = [
      '001_initial_schema.sql',
      '002_seed_data.sql'
    ];
    
    for (const migrationFile of migrationFiles) {
      const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', migrationFile);
      
      if (!fs.existsSync(migrationPath)) {
        console.error(`❌ Migration file not found: ${migrationFile}`);
        continue;
      }
      
      const success = await runMigration(migrationFile);
      if (!success) {
        console.error(`❌ Failed to run migration: ${migrationFile}`);
        process.exit(1);
      }
    }
  } else {
    console.log('ℹ️  Database schema already exists, skipping migration');
  }
  
  // Verify setup
  console.log('🔍 Verifying database setup...');
  
  try {
    const { data: regions, error: regionsError } = await supabase
      .from('regions')
      .select('count');
    
    if (regionsError) throw regionsError;
    
    const { data: recipes, error: recipesError } = await supabase
      .from('recipes')
      .select('count');
    
    if (recipesError) throw recipesError;
    
    console.log('✅ Database verification successful');
    console.log(`📊 Found ${regions?.[0]?.count || 0} regions and ${recipes?.[0]?.count || 0} recipes`);
  } catch (error) {
    console.error('❌ Database verification failed:', error.message);
  }
  
  console.log('\n🎉 Database setup complete!');
  console.log('\n📝 Next steps:');
  console.log('1. Your Supabase database is now ready');
  console.log('2. You can start using the app');
  console.log('3. Check the Supabase dashboard to view your data');
  console.log('4. Consider setting up storage buckets for images');
}

// Handle command line arguments
const args = process.argv.slice(2);

if (args.includes('--help') || args.includes('-h')) {
  console.log(`
African Meal Planner Database Setup

Usage: node scripts/setup-database.js [options]

Options:
  --help, -h     Show this help message
  --force        Force recreation of database schema
  --test-only    Only test the connection, don't run migrations

Environment Variables Required:
  EXPO_PUBLIC_SUPABASE_URL      Your Supabase project URL
  SUPABASE_SERVICE_ROLE_KEY     Your Supabase service role key (or anon key)

Example:
  node scripts/setup-database.js
  `);
  process.exit(0);
}

if (args.includes('--test-only')) {
  testConnection().then(success => {
    process.exit(success ? 0 : 1);
  });
} else {
  setupDatabase().catch(error => {
    console.error('❌ Setup failed:', error);
    process.exit(1);
  });
}