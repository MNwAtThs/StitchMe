# Supabase Setup Guide for StitchMe

This guide will walk you through setting up Supabase for authentication and patient data storage in the StitchMe project.

## 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Click "New Project"
3. Choose your organization
4. Fill in project details:
   - **Name**: `stitchme-production` (or `stitchme-dev` for development)
   - **Database Password**: Generate a strong password
   - **Region**: Choose closest to your users
5. Click "Create new project"
6. Wait for the project to be ready (usually 2-3 minutes)

## 2. Get Project Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL** (e.g., `https://your-project.supabase.co`)
   - **anon public** key
   - **service_role** key (keep this secret!)

## 3. Configure Environment Variables

Create a `.env` file in your project root:

```bash
# Copy from env.example
cp env.example .env
```

Update the `.env` file with your Supabase credentials:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Supabase Storage Configuration
SUPABASE_STORAGE_BUCKET_PATIENT_IMAGES=patient-images
SUPABASE_STORAGE_BUCKET_MEDICAL_FILES=medical-files
```

## 4. Set Up Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Copy the contents of `supabase-schema.sql` from your project root
3. Paste it into the SQL Editor
4. Click **Run** to execute the schema

This will create:
- User profiles and authentication tables
- Patient and healthcare provider profiles
- Wound assessment tables
- Medical records and treatment plans
- Video session management
- Row Level Security (RLS) policies for HIPAA compliance

## 5. Configure Authentication

1. Go to **Authentication** → **Settings**
2. Configure the following:

### Site URL
- **Development**: `http://localhost:3000`
- **Production**: `https://your-domain.com`

### Redirect URLs
Add these URLs (comma-separated):
```
http://localhost:3000/auth/callback,
https://your-domain.com/auth/callback,
http://localhost:8080/auth/callback
```

### Email Settings
1. Go to **Authentication** → **Email Templates**
2. Customize the confirmation and recovery email templates
3. Configure SMTP settings if you want to use your own email service

## 6. Set Up Storage Buckets

1. Go to **Storage** in your Supabase dashboard
2. Create two buckets:

### Patient Images Bucket
- **Name**: `patient-images`
- **Public**: ✅ (for easy access to wound images)
- **File size limit**: 10MB
- **Allowed MIME types**: `image/*`

### Medical Files Bucket
- **Name**: `medical-files`
- **Public**: ❌ (private medical documents)
- **File size limit**: 10MB
- **Allowed MIME types**: `image/*,application/pdf,text/*`

## 7. Configure Row Level Security (RLS)

The schema already includes RLS policies, but you can review them:

1. Go to **Authentication** → **Policies**
2. Review the policies for each table
3. Ensure they follow HIPAA compliance requirements

### Key RLS Policies:
- Users can only access their own data
- Healthcare providers can access patient data they're treating
- Medical records are protected by patient-provider relationships

## 8. Test the Setup

### Test Authentication
```bash
# Start the API server
cd services/api
npm run dev

# Test registration
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "fullName": "Test User",
    "userType": "patient"
  }'

# Test login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Test Flutter App
```bash
# Start Flutter app
cd apps/flutter_app
flutter run -d chrome
```

## 9. HIPAA Compliance Considerations

### Data Encryption
- Supabase encrypts data at rest and in transit
- All connections use TLS 1.2+
- Database is encrypted with AES-256

### Access Controls
- RLS policies ensure data isolation
- Audit logs track all data access
- User authentication is required for all operations

### Backup and Recovery
- Supabase provides automated backups
- Point-in-time recovery available
- Data retention policies can be configured

## 10. Production Deployment

### Environment Variables
Set these in your production environment:
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_production_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_production_service_role_key
```

### Security Checklist
- [ ] Enable email confirmation
- [ ] Set up proper CORS origins
- [ ] Configure rate limiting
- [ ] Enable audit logging
- [ ] Set up monitoring and alerts
- [ ] Review and test RLS policies
- [ ] Configure backup retention

## 11. Monitoring and Maintenance

### Supabase Dashboard
- Monitor API usage and performance
- Review authentication logs
- Check storage usage
- Monitor database performance

### Health Checks
```bash
# Check API health
curl http://localhost:3000/health

# Check Supabase connection
curl -H "Authorization: Bearer YOUR_ANON_KEY" \
  https://your-project.supabase.co/rest/v1/profiles
```

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Check API keys are correct
   - Verify CORS settings
   - Ensure email confirmation is working

2. **RLS Policy Errors**
   - Check user permissions
   - Verify table policies
   - Test with different user types

3. **Storage Upload Errors**
   - Check bucket permissions
   - Verify file size limits
   - Check MIME type restrictions

### Support Resources
- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Community](https://github.com/supabase/supabase/discussions)
- [StitchMe Issues](https://github.com/your-repo/StitchMe/issues)

## Next Steps

1. Set up your Supabase project following this guide
2. Configure your environment variables
3. Run the database schema
4. Test authentication and data operations
5. Deploy to production with proper security measures

For questions or issues, please refer to the project documentation or create an issue in the repository.
