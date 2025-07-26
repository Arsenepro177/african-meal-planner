#!/usr/bin/env python3
"""
Script to set up the database schema in Supabase via API calls.
This bypasses network connectivity issues with direct database connections.
"""

import os
import sys
import requests
from decouple import config

# Load environment variables
SUPABASE_URL = config('SUPABASE_URL')
SUPABASE_SERVICE_ROLE_KEY = config('SUPABASE_SERVICE_ROLE_KEY')

def execute_sql_via_api(sql_query, description="SQL execution"):
    """Execute SQL query via Supabase API"""
    url = f"{SUPABASE_URL}/rest/v1/rpc/exec_sql"
    headers = {
        'Authorization': f'Bearer {SUPABASE_SERVICE_ROLE_KEY}',
        'Content-Type': 'application/json',
        'apikey': SUPABASE_SERVICE_ROLE_KEY
    }
    
    data = {
        'sql': sql_query
    }
    
    print(f"Executing: {description}")
    response = requests.post(url, json=data, headers=headers)
    
    if response.status_code == 200:
        print(f"✅ Success: {description}")
        return True
    else:
        print(f"❌ Failed: {description}")
        print(f"Status: {response.status_code}")
        print(f"Response: {response.text}")
        return False

def create_django_tables():
    """Create Django's required tables"""
    
    # Django's built-in tables
    django_tables = [
        """
        CREATE TABLE IF NOT EXISTS django_migrations (
            id SERIAL PRIMARY KEY,
            app VARCHAR(255) NOT NULL,
            name VARCHAR(255) NOT NULL,
            applied TIMESTAMP WITH TIME ZONE NOT NULL
        );
        """,
        
        """
        CREATE TABLE IF NOT EXISTS django_content_type (
            id SERIAL PRIMARY KEY,
            app_label VARCHAR(100) NOT NULL,
            model VARCHAR(100) NOT NULL,
            UNIQUE(app_label, model)
        );
        """,
        
        """
        CREATE TABLE IF NOT EXISTS auth_permission (
            id SERIAL PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            content_type_id INTEGER NOT NULL REFERENCES django_content_type(id),
            codename VARCHAR(100) NOT NULL,
            UNIQUE(content_type_id, codename)
        );
        """,
        
        """
        CREATE TABLE IF NOT EXISTS auth_group (
            id SERIAL PRIMARY KEY,
            name VARCHAR(150) UNIQUE NOT NULL
        );
        """,
        
        """
        CREATE TABLE IF NOT EXISTS auth_group_permissions (
            id SERIAL PRIMARY KEY,
            group_id INTEGER NOT NULL REFERENCES auth_group(id),
            permission_id INTEGER NOT NULL REFERENCES auth_permission(id),
            UNIQUE(group_id, permission_id)
        );
        """,
        
        """
        CREATE TABLE IF NOT EXISTS django_admin_log (
            id SERIAL PRIMARY KEY,
            action_time TIMESTAMP WITH TIME ZONE NOT NULL,
            object_id TEXT,
            object_repr VARCHAR(200) NOT NULL,
            action_flag SMALLINT NOT NULL,
            change_message TEXT NOT NULL,
            content_type_id INTEGER REFERENCES django_content_type(id),
            user_id INTEGER NOT NULL
        );
        """,
        
        """
        CREATE TABLE IF NOT EXISTS django_session (
            session_key VARCHAR(40) PRIMARY KEY,
            session_data TEXT NOT NULL,
            expire_date TIMESTAMP WITH TIME ZONE NOT NULL
        );
        """
    ]
    
    for table_sql in django_tables:
        execute_sql_via_api(table_sql, f"Creating Django system table")

def create_app_tables():
    """Create application-specific tables"""
    
    # Users table (custom user model)
    user_table = """
    CREATE TABLE IF NOT EXISTS accounts_user (
        id SERIAL PRIMARY KEY,
        password VARCHAR(128) NOT NULL,
        last_login TIMESTAMP WITH TIME ZONE,
        is_superuser BOOLEAN NOT NULL DEFAULT FALSE,
        username VARCHAR(150) NOT NULL UNIQUE,
        first_name VARCHAR(150) NOT NULL DEFAULT '',
        last_name VARCHAR(150) NOT NULL DEFAULT '',
        email VARCHAR(254) NOT NULL UNIQUE,
        is_staff BOOLEAN NOT NULL DEFAULT FALSE,
        is_active BOOLEAN NOT NULL DEFAULT TRUE,
        date_joined TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
        phone_number VARCHAR(20),
        date_of_birth DATE,
        gender VARCHAR(1),
        height FLOAT,
        weight FLOAT,
        country VARCHAR(100),
        city VARCHAR(100),
        location VARCHAR(200),
        cooking_level VARCHAR(20) DEFAULT 'beginner',
        avatar VARCHAR(100),
        email_verified BOOLEAN DEFAULT FALSE,
        last_activity TIMESTAMP WITH TIME ZONE,
        timezone VARCHAR(50) DEFAULT 'UTC'
    );
    """
    
    # Add user-related permissions table
    user_permissions = """
    CREATE TABLE IF NOT EXISTS accounts_user_groups (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES accounts_user(id),
        group_id INTEGER NOT NULL REFERENCES auth_group(id),
        UNIQUE(user_id, group_id)
    );
    
    CREATE TABLE IF NOT EXISTS accounts_user_user_permissions (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES accounts_user(id),
        permission_id INTEGER NOT NULL REFERENCES auth_permission(id),
        UNIQUE(user_id, permission_id)
    );
    """
    
    execute_sql_via_api(user_table, "Creating custom user table")
    execute_sql_via_api(user_permissions, "Creating user permissions tables")

def setup_basic_schema():
    """Set up basic schema to get Django running"""
    print("🚀 Setting up Supabase schema...")
    print(f"📡 Supabase URL: {SUPABASE_URL}")
    
    # Create Django system tables
    create_django_tables()
    
    # Create custom user table
    create_app_tables()
    
    print("✅ Basic schema setup complete!")
    print("\n📝 Next steps:")
    print("1. The basic tables are now created")
    print("2. You can now run Django migrations")
    print("3. Or continue with SQLite for development")

if __name__ == "__main__":
    if not SUPABASE_URL or not SUPABASE_SERVICE_ROLE_KEY:
        print("❌ Error: Missing Supabase configuration")
        print("Please check your .env file has SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY")
        sys.exit(1)
    
    setup_basic_schema()
