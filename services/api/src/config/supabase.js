const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

// Debug logging
console.log('🔍 Environment variables check:');
console.log('SUPABASE_URL:', process.env.SUPABASE_URL ? '✅ SET' : '❌ MISSING');
console.log('SUPABASE_ANON_KEY:', process.env.SUPABASE_ANON_KEY ? '✅ SET' : '❌ MISSING');
console.log('SUPABASE_SERVICE_ROLE_KEY:', process.env.SUPABASE_SERVICE_ROLE_KEY ? '✅ SET' : '❌ MISSING');

// Supabase client configuration
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseAnonKey || !supabaseServiceKey) {
    console.error('❌ Missing required Supabase environment variables:');
    if (!supabaseUrl) console.error('  - SUPABASE_URL');
    if (!supabaseAnonKey) console.error('  - SUPABASE_ANON_KEY');
    if (!supabaseServiceKey) console.error('  - SUPABASE_SERVICE_ROLE_KEY');
    console.error('\n📝 Please create a .env file in the services/api directory with your Supabase credentials.');
    throw new Error('Missing required Supabase environment variables');
}

// Client for user operations (uses anon key)
const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Admin client for server-side operations (uses service role key)
const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
    auth: {
        autoRefreshToken: false,
        persistSession: false
    }
});

// Storage bucket names
const STORAGE_BUCKETS = {
    PATIENT_IMAGES: process.env.SUPABASE_STORAGE_BUCKET_PATIENT_IMAGES || 'patient-images',
    MEDICAL_FILES: process.env.SUPABASE_STORAGE_BUCKET_MEDICAL_FILES || 'medical-files'
};

module.exports = {
    supabase,
    supabaseAdmin,
    STORAGE_BUCKETS
};
