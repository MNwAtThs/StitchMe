class AppConstants {
  // App Information
  static const String appName = 'StitchMe';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-Powered Wound Assessment and Treatment System';
  
  // API Endpoints
  static const String apiBaseUrl = 'http://localhost:3000/api';
  static const String aiServiceUrl = 'http://localhost:8000';
  static const String webrtcSignalingUrl = 'ws://localhost:3001';
  
  // Database Tables
  static const String profilesTable = 'profiles';
  static const String devicesTable = 'devices';
  static const String woundAssessmentsTable = 'wound_assessments';
  static const String videoSessionsTable = 'video_sessions';
  
  // Storage Buckets
  static const String imagesBucket = 'wound-images';
  static const String videosBucket = 'session-recordings';
  static const String documentsBucket = 'medical-documents';
  
  // File Limits
  static const int maxImageSizeMB = 10;
  static const int maxVideoSizeMB = 100;
  static const int maxImagesPerAssessment = 5;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  
  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 100;
  static const int maxEmailLength = 254;
  
  // Device Communication
  static const Duration deviceTimeoutDuration = Duration(seconds: 30);
  static const Duration heartbeatInterval = Duration(seconds: 10);
  static const int maxRetryAttempts = 3;
  
  // Medical Constants
  static const double minWoundAreaCm2 = 0.1;
  static const double maxWoundAreaCm2 = 1000.0;
  static const int maxAssessmentHistoryDays = 365;
  
  // Feature Flags
  static const bool enableLiDAR = true;
  static const bool enableVideoCall = true;
  static const bool enableDeviceSimulation = true;
  static const bool enableOfflineMode = false;
}
