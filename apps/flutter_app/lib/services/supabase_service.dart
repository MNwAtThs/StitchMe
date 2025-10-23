import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_models/shared_models.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late SupabaseClient _client;
  SupabaseClient get client => _client;

  Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    _client = Supabase.instance.client;
  }

  // Authentication methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String userType,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'user_type': userType,
      },
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;

  // Profile management
  Future<UserModel> getProfile() async {
    final response = await _client
        .from('profiles')
        .select('*')
        .eq('id', currentUser!.id)
        .single();

    return UserModel.fromJson(response);
  }

  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    await _client
        .from('profiles')
        .update({
          if (fullName != null) 'full_name': fullName,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', currentUser!.id);
  }

  // Patient profile management
  Future<Map<String, dynamic>?> getPatientProfile() async {
    final response = await _client
        .from('patient_profiles')
        .select('*')
        .eq('id', currentUser!.id)
        .maybeSingle();

    return response;
  }

  Future<void> updatePatientProfile({
    DateTime? dateOfBirth,
    double? height,
    double? weight,
    String? bloodType,
    List<String>? allergies,
    Map<String, dynamic>? medicalHistory,
    Map<String, dynamic>? emergencyContact,
  }) async {
    await _client
        .from('patient_profiles')
        .upsert({
          'id': currentUser!.id,
          if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
          if (height != null) 'height': height,
          if (weight != null) 'weight': weight,
          if (bloodType != null) 'blood_type': bloodType,
          if (allergies != null) 'allergies': allergies,
          if (medicalHistory != null) 'medical_history': medicalHistory,
          if (emergencyContact != null) 'emergency_contact': emergencyContact,
          'updated_at': DateTime.now().toIso8601String(),
        });
  }

  // Wound assessments
  Future<List<WoundAssessment>> getWoundAssessments({
    int page = 1,
    int limit = 10,
  }) async {
    final offset = (page - 1) * limit;
    
    final response = await _client
        .from('wound_assessments')
        .select('''
          *,
          devices(device_name, device_type)
        ''')
        .eq('patient_id', currentUser!.id)
        .order('created_at', desc: true)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => WoundAssessment.fromJson(json))
        .toList();
  }

  Future<WoundAssessment> createWoundAssessment({
    required List<String> imageUrls,
    String? deviceId,
    Map<String, dynamic>? lidarData,
    Map<String, dynamic>? aiAnalysis,
    required int severityScore,
    required String treatmentRecommendation,
    required bool requiresProfessional,
    String? locationOnBody,
    String? woundType,
    Map<String, dynamic>? measurements,
  }) async {
    final response = await _client
        .from('wound_assessments')
        .insert({
          'patient_id': currentUser!.id,
          if (deviceId != null) 'device_id': deviceId,
          'images': imageUrls,
          if (lidarData != null) 'lidar_data': lidarData,
          if (aiAnalysis != null) 'ai_analysis': aiAnalysis,
          'severity_score': severityScore,
          'treatment_recommendation': treatmentRecommendation,
          'requires_professional': requiresProfessional,
          if (locationOnBody != null) 'location_on_body': locationOnBody,
          if (woundType != null) 'wound_type': woundType,
          if (measurements != null) 'measurements': measurements,
        })
        .select()
        .single();

    return WoundAssessment.fromJson(response);
  }

  // Medical records
  Future<List<Map<String, dynamic>>> getMedicalRecords({
    int page = 1,
    int limit = 10,
    String? recordType,
  }) async {
    final offset = (page - 1) * limit;
    
    var query = _client
        .from('medical_records')
        .select('''
          *,
          profiles!medical_records_provider_id_fkey(full_name, user_type)
        ''')
        .eq('patient_id', currentUser!.id)
        .order('created_at', desc: true)
        .range(offset, offset + limit - 1);

    if (recordType != null) {
      query = query.eq('record_type', recordType);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }

  // Treatment plans
  Future<List<Map<String, dynamic>>> getTreatmentPlans({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final offset = (page - 1) * limit;
    
    var query = _client
        .from('treatment_plans')
        .select('''
          *,
          profiles!treatment_plans_provider_id_fkey(full_name, user_type),
          wound_assessments(id, severity_score, treatment_recommendation)
        ''')
        .eq('patient_id', currentUser!.id)
        .order('created_at', desc: true)
        .range(offset, offset + limit - 1);

    if (status != null) {
      query = query.eq('status', status);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }

  // File upload to Supabase Storage
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required List<int> fileBytes,
    String? contentType,
  }) async {
    final response = await _client.storage
        .from(bucket)
        .uploadBinary(path, fileBytes, fileOptions: FileOptions(
          contentType: contentType,
          cacheControl: '3600',
        ));

    if (response.isNotEmpty) {
      final publicUrl = _client.storage
          .from(bucket)
          .getPublicUrl(path);
      return publicUrl;
    }

    throw Exception('Failed to upload file');
  }

  // Real-time subscriptions
  RealtimeChannel subscribeToWoundAssessments({
    required void Function(WoundAssessment) onInsert,
    required void Function(WoundAssessment) onUpdate,
    required void Function(WoundAssessment) onDelete,
  }) {
    return _client
        .channel('wound_assessments')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'wound_assessments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'patient_id',
            value: currentUser!.id,
          ),
          callback: (payload) {
            final assessment = WoundAssessment.fromJson(payload.newRecord);
            onInsert(assessment);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'wound_assessments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'patient_id',
            value: currentUser!.id,
          ),
          callback: (payload) {
            final assessment = WoundAssessment.fromJson(payload.newRecord);
            onUpdate(assessment);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'wound_assessments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'patient_id',
            value: currentUser!.id,
          ),
          callback: (payload) {
            final assessment = WoundAssessment.fromJson(payload.oldRecord);
            onDelete(assessment);
          },
        )
        .subscribe();
  }

  // Cleanup
  void dispose() {
    _client.realtime.disconnect();
  }
}
