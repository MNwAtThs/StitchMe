# 🔐 Supabase Authentication Setup Guide

Your StitchMe app uses Supabase for authentication and loads credentials from the `.env` file.

## ✅ **Setup Complete!**

The Flutter app loads Supabase credentials from:
- **File**: `services/api/.env` (in .gitignore - secure!)
- **Status**: ✅ Ready to use

## 🔧 **How It Works**

1. **Flutter app** loads `services/api/.env` file
2. **Uses** your Supabase credentials
3. **Connects** to your Supabase project
4. **Simple and secure!**

## 🗄️ **Step 4: Set Up Database Schema**

1. In your Supabase dashboard, go to **SQL Editor**
2. Copy the contents of `supabase-schema.sql` from your project root
3. Paste it into the SQL Editor
4. Click **Run** to execute the schema

This will create:
- User profiles and authentication tables
- Patient and healthcare provider profiles
- Wound assessment tables
- Medical records and treatment plans
- Row Level Security (RLS) policies for HIPAA compliance

## 🔐 **Step 5: Configure Authentication**

1. Go to **Authentication** → **Settings**
2. Configure the following:

### Site URL
- **Development**: `http://localhost:3000`
- **Production**: Your production domain

### Redirect URLs
- **Development**: `http://localhost:3000/auth/callback`
- **Production**: `https://yourdomain.com/auth/callback`

## 🚀 **Step 6: Test Your Setup**

1. Run your Flutter app: `flutter run`
2. Try creating a new account
3. Try signing in with the created account
4. Check your Supabase dashboard to see the user data

## 📱 **What's Now Working**

✅ **Real Authentication**: Users can sign up and sign in with Supabase
✅ **User Profiles**: Patient profiles are created with medical information
✅ **Data Persistence**: All user data is stored in Supabase
✅ **Security**: Row Level Security (RLS) protects user data
✅ **Sign Out**: Users can properly sign out and clear their session

## 🔧 **Troubleshooting**

### Common Issues:

1. **"Invalid API key"**: Check your credentials in `app_config.dart`
2. **"User not found"**: Make sure the database schema is set up
3. **"Permission denied"**: Check RLS policies in Supabase

### Need Help?

- Check the [Supabase Documentation](https://supabase.com/docs)
- Review the `supabase-schema.sql` file for table structure
- Check the `services/supabase_service.dart` for available methods

## 🎉 **You're All Set!**

Your StitchMe app now has real authentication powered by Supabase! Users can create accounts, sign in, and their data will be securely stored in your Supabase database.
