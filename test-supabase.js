const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

// Get environment variables
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

console.log('Testing Supabase Connection...');
console.log('URL:', supabaseUrl ? `${supabaseUrl.slice(0, 30)}...` : 'Not found');
console.log('Anon Key:', supabaseAnonKey ? `${supabaseAnonKey.slice(0, 20)}...` : 'Not found');

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('❌ Missing Supabase credentials in environment variables');
  process.exit(1);
}

// Create Supabase client
const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function testConnection() {
  try {
    // Test basic connection
    const { data, error } = await supabase
      .from('auth_user')
      .select('count')
      .limit(1);

    if (error) {
      console.error('❌ Connection failed:', error.message);
      return false;
    } else {
      console.log('✅ Supabase connection successful!');
      return true;
    }
  } catch (err) {
    console.error('❌ Connection error:', err.message);
    return false;
  }
}

// Test authentication
async function testAuth() {
  try {
    const { data: { user }, error } = await supabase.auth.getUser();
    
    if (error && error.message !== 'Invalid JWT') {
      console.error('❌ Auth test failed:', error.message);
      return false;
    } else {
      console.log('✅ Authentication system working!');
      console.log('Current user:', user ? 'Authenticated' : 'Not authenticated (expected)');
      return true;
    }
  } catch (err) {
    console.error('❌ Auth error:', err.message);
    return false;
  }
}

async function runTests() {
  console.log('\n🔍 Testing Supabase Setup...\n');
  
  const connectionTest = await testConnection();
  const authTest = await testAuth();
  
  console.log('\n📊 Test Results:');
  console.log(`Database Connection: ${connectionTest ? '✅' : '❌'}`);
  console.log(`Authentication: ${authTest ? '✅' : '❌'}`);
  
  if (connectionTest && authTest) {
    console.log('\n🎉 All tests passed! Your Supabase setup is working correctly.');
  } else {
    console.log('\n⚠️  Some tests failed. Please check your configuration.');
  }
}

runTests();
