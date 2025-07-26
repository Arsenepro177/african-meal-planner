# Supabase Setup Guide for African Meal Planner

This guide will help you connect your African Meal Planner project to Supabase.

## Prerequisites

1. A Supabase account (sign up at [supabase.com](https://supabase.com))
2. Node.js and npm/yarn installed
3. Python 3.8+ installed
4. PostgreSQL knowledge (basic)

## Step 1: Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Choose your organization
4. Fill in your project details:
   - Name: `african-meal-planner`
   - Database Password: Choose a strong password
   - Region: Choose the closest to your users
5. Click "Create New Project"

## Step 2: Get Your Project Credentials

1. Once your project is created, go to **Settings > API**
2. Copy the following values:
   - **Project URL** (looks like: `https://abcdefghijklmnop.supabase.co`)
   - **Anon/Public Key** (starts with `eyJ...`)
   - **Service Role Key** (starts with `eyJ...` - keep this secret!)

3. Go to **Settings > Database**
4. Copy the database connection details:
   - **Host**: `db.your-project-id.supabase.co`
   - **Database name**: `postgres`
   - **Username**: `postgres`
   - **Password**: The password you set when creating the project
   - **Port**: `5432`

## Step 3: Configure the Backend (Django)

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Create a `.env` file from the example:
   ```bash
   cp .env.example .env
   ```

3. Edit the `.env` file and fill in your Supabase credentials:
   ```env
   # Supabase Configuration
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

   # Database Configuration
   SUPABASE_DB_HOST=db.your-project-id.supabase.co
   SUPABASE_DB_NAME=postgres
   SUPABASE_DB_USER=postgres
   SUPABASE_DB_PASSWORD=your-database-password
   SUPABASE_DB_PORT=5432
   ```

4. Install the new dependencies:
   ```bash
   pip install -r requirements.txt
   ```

5. Run Django migrations to create your tables in Supabase:
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

6. Create a Django superuser:
   ```bash
   python manage.py createsuperuser
   ```

## Step 4: Configure the Frontend (React Native)

1. Navigate back to the project root:
   ```bash
   cd ..
   ```

2. Create a `.env` file from the example:
   ```bash
   cp .env.example .env
   ```

3. Edit the `.env` file and fill in your Supabase credentials:
   ```env
   # Supabase Configuration
   EXPO_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
   EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
   ```

4. Install the new dependencies:
   ```bash
   npm install
   # or
   yarn install
   ```

## Step 5: Set Up Supabase Storage (Optional)

If you want to store images (user avatars, recipe photos), you'll need to set up storage buckets:

1. Go to your Supabase dashboard
2. Navigate to **Storage**
3. Create the following buckets:
   - `avatars` (for user profile pictures)
   - `recipe-images` (for recipe photos)
   - `user-uploads` (for other user uploads)

4. Set appropriate policies for each bucket (public read for images, authenticated write)

## Step 6: Set Up Row Level Security (RLS)

1. Go to **Authentication > Policies** in your Supabase dashboard
2. Enable RLS on your tables
3. Create policies to secure your data:

Example policy for the `auth_user` table:
```sql
-- Allow users to view their own profile
CREATE POLICY "Users can view own profile" ON auth_user
FOR SELECT USING (auth.uid()::text = id::text);

-- Allow users to update their own profile
CREATE POLICY "Users can update own profile" ON auth_user
FOR UPDATE USING (auth.uid()::text = id::text);
```

## Step 7: Test the Connection

1. Start your Django backend:
   ```bash
   cd backend
   python manage.py runserver
   ```

2. In a new terminal, start your React Native app:
   ```bash
   npm run dev
   ```

3. Check if the connection works by:
   - Visiting the Django admin at `http://localhost:8000/admin`
   - Testing user registration/login in your React Native app

## Step 8: Deploy Your Database Schema

You can use the provided `schema.sql` file to set up your database structure:

1. Go to **SQL Editor** in your Supabase dashboard
2. Copy the contents of `schema.sql`
3. Run the SQL to create all your tables

Or use Django migrations (recommended):
```bash
cd backend
python manage.py migrate
```

## Common Issues and Solutions

### Connection Issues
- Make sure your database password is correct
- Check that your Supabase project is active
- Verify that SSL is enabled in your database connection

### Authentication Issues
- Ensure your anon key is correct
- Check that your Supabase URL doesn't have a trailing slash
- Verify environment variables are loaded correctly

### Migration Issues
- Make sure PostgreSQL is the database engine in Django settings
- Check that your database credentials are correct
- Ensure your Django user has the necessary permissions

## Environment Variables Summary

### Backend (.env in backend/ directory):
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
SUPABASE_DB_HOST=db.your-project-id.supabase.co
SUPABASE_DB_NAME=postgres
SUPABASE_DB_USER=postgres
SUPABASE_DB_PASSWORD=your-database-password
SUPABASE_DB_PORT=5432
```

### Frontend (.env in project root):
```env
EXPO_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

## Next Steps

1. Set up authentication flow in your React Native app
2. Configure real-time subscriptions for live updates
3. Implement file upload functionality for user avatars and recipe images
4. Set up proper error handling and loading states
5. Configure push notifications (if needed)

## Support

If you encounter any issues:
1. Check the Supabase documentation: [supabase.com/docs](https://supabase.com/docs)
2. Review the Django documentation for database configuration
3. Check your environment variables are properly set
4. Ensure your network allows connections to Supabase servers

Happy coding! 🚀
