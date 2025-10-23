-- StitchMe Supabase Database Schema
-- This file contains all the SQL commands to set up the database schema

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create profiles table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  user_type TEXT CHECK (user_type IN ('patient', 'healthcare_provider')) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create patient profiles table
CREATE TABLE IF NOT EXISTS patient_profiles (
  id UUID REFERENCES profiles(id) ON DELETE CASCADE PRIMARY KEY,
  date_of_birth DATE,
  height DECIMAL(5,2), -- in cm
  weight DECIMAL(5,2), -- in kg
  blood_type TEXT,
  allergies TEXT[],
  medical_history JSONB,
  emergency_contact JSONB,
  insurance_info JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create healthcare provider profiles table
CREATE TABLE IF NOT EXISTS healthcare_provider_profiles (
  id UUID REFERENCES profiles(id) ON DELETE CASCADE PRIMARY KEY,
  license_number TEXT UNIQUE,
  specialization TEXT,
  hospital_affiliation TEXT,
  department TEXT,
  verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create devices table
CREATE TABLE IF NOT EXISTS devices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_name TEXT NOT NULL,
  device_type TEXT CHECK (device_type IN ('stitchme_device', 'mobile_phone', 'tablet', 'desktop')) NOT NULL,
  owner_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  status TEXT DEFAULT 'offline' CHECK (status IN ('offline', 'online', 'connecting', 'error')),
  last_seen TIMESTAMP WITH TIME ZONE,
  configuration JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create wound assessments table
CREATE TABLE IF NOT EXISTS wound_assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  device_id UUID REFERENCES devices(id) ON DELETE SET NULL,
  images TEXT[], -- URLs to stored images in Supabase Storage
  lidar_data JSONB, -- 3D scan data
  ai_analysis JSONB, -- AI results and confidence scores
  severity_score INTEGER CHECK (severity_score >= 1 AND severity_score <= 4), -- 1=minor, 2=moderate, 3=severe, 4=critical
  treatment_recommendation TEXT,
  requires_professional BOOLEAN DEFAULT FALSE,
  location_on_body TEXT, -- e.g., "left_arm", "right_leg"
  wound_type TEXT, -- e.g., "laceration", "burn", "ulcer"
  measurements JSONB, -- width, depth, area measurements
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create video sessions table
CREATE TABLE IF NOT EXISTS video_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  provider_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  assessment_id UUID REFERENCES wound_assessments(id) ON DELETE SET NULL,
  session_status TEXT DEFAULT 'pending' CHECK (session_status IN ('pending', 'active', 'completed', 'cancelled')),
  started_at TIMESTAMP WITH TIME ZONE,
  ended_at TIMESTAMP WITH TIME ZONE,
  recording_url TEXT,
  session_notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create medical records table
CREATE TABLE IF NOT EXISTS medical_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  provider_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  record_type TEXT CHECK (record_type IN ('assessment', 'treatment', 'prescription', 'lab_result', 'imaging')) NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  data JSONB, -- Flexible structure for different record types
  attachments TEXT[], -- URLs to files in Supabase Storage
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create treatment plans table
CREATE TABLE IF NOT EXISTS treatment_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  provider_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  assessment_id UUID REFERENCES wound_assessments(id) ON DELETE SET NULL,
  plan_name TEXT NOT NULL,
  description TEXT,
  steps JSONB, -- Array of treatment steps
  medications JSONB, -- Prescribed medications
  follow_up_date DATE,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE patient_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE healthcare_provider_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE wound_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE treatment_plans ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for profiles
CREATE POLICY "Users can view own profile" ON profiles 
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles 
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles 
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Create RLS policies for patient_profiles
CREATE POLICY "Patients can view own profile" ON patient_profiles 
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Patients can update own profile" ON patient_profiles 
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Patients can insert own profile" ON patient_profiles 
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Create RLS policies for healthcare_provider_profiles
CREATE POLICY "Providers can view own profile" ON healthcare_provider_profiles 
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Providers can update own profile" ON healthcare_provider_profiles 
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Providers can insert own profile" ON healthcare_provider_profiles 
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Create RLS policies for devices
CREATE POLICY "Users can view own devices" ON devices 
  FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Users can update own devices" ON devices 
  FOR UPDATE USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert own devices" ON devices 
  FOR INSERT WITH CHECK (auth.uid() = owner_id);

-- Create RLS policies for wound_assessments
CREATE POLICY "Patients can view own assessments" ON wound_assessments 
  FOR SELECT USING (auth.uid() = patient_id);

CREATE POLICY "Providers can view patient assessments" ON wound_assessments 
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM video_sessions 
      WHERE assessment_id = wound_assessments.id 
      AND provider_id = auth.uid()
    )
  );

CREATE POLICY "Patients can insert own assessments" ON wound_assessments 
  FOR INSERT WITH CHECK (auth.uid() = patient_id);

-- Create RLS policies for video_sessions
CREATE POLICY "Participants can view own sessions" ON video_sessions 
  FOR SELECT USING (auth.uid() = patient_id OR auth.uid() = provider_id);

CREATE POLICY "Providers can insert sessions" ON video_sessions 
  FOR INSERT WITH CHECK (auth.uid() = provider_id);

CREATE POLICY "Participants can update own sessions" ON video_sessions 
  FOR UPDATE USING (auth.uid() = patient_id OR auth.uid() = provider_id);

-- Create RLS policies for medical_records
CREATE POLICY "Patients can view own records" ON medical_records 
  FOR SELECT USING (auth.uid() = patient_id);

CREATE POLICY "Providers can view patient records" ON medical_records 
  FOR SELECT USING (auth.uid() = provider_id);

CREATE POLICY "Providers can insert records" ON medical_records 
  FOR INSERT WITH CHECK (auth.uid() = provider_id);

CREATE POLICY "Providers can update records" ON medical_records 
  FOR UPDATE USING (auth.uid() = provider_id);

-- Create RLS policies for treatment_plans
CREATE POLICY "Patients can view own treatment plans" ON treatment_plans 
  FOR SELECT USING (auth.uid() = patient_id);

CREATE POLICY "Providers can view patient treatment plans" ON treatment_plans 
  FOR SELECT USING (auth.uid() = provider_id);

CREATE POLICY "Providers can insert treatment plans" ON treatment_plans 
  FOR INSERT WITH CHECK (auth.uid() = provider_id);

CREATE POLICY "Providers can update treatment plans" ON treatment_plans 
  FOR UPDATE USING (auth.uid() = provider_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_profiles_user_type ON profiles(user_type);
CREATE INDEX IF NOT EXISTS idx_devices_owner_id ON devices(owner_id);
CREATE INDEX IF NOT EXISTS idx_devices_status ON devices(status);
CREATE INDEX IF NOT EXISTS idx_wound_assessments_patient_id ON wound_assessments(patient_id);
CREATE INDEX IF NOT EXISTS idx_wound_assessments_created_at ON wound_assessments(created_at);
CREATE INDEX IF NOT EXISTS idx_video_sessions_patient_id ON video_sessions(patient_id);
CREATE INDEX IF NOT EXISTS idx_video_sessions_provider_id ON video_sessions(provider_id);
CREATE INDEX IF NOT EXISTS idx_medical_records_patient_id ON medical_records(patient_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_patient_id ON treatment_plans(patient_id);

-- Create function to automatically create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, user_type)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'user_type', 'patient')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically create profile
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_patient_profiles_updated_at BEFORE UPDATE ON patient_profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_healthcare_provider_profiles_updated_at BEFORE UPDATE ON healthcare_provider_profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_devices_updated_at BEFORE UPDATE ON devices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_wound_assessments_updated_at BEFORE UPDATE ON wound_assessments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_video_sessions_updated_at BEFORE UPDATE ON video_sessions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_medical_records_updated_at BEFORE UPDATE ON medical_records FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_treatment_plans_updated_at BEFORE UPDATE ON treatment_plans FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
