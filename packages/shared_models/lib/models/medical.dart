enum WoundSeverity { minor, moderate, severe, critical }

enum TreatmentType { cleaning, bandaging, stitching, professionalCare }

class WoundAssessment {
  final String id;
  final String patientId;
  final String? deviceId;
  final List<String> imageUrls;
  final Map<String, dynamic>? lidarData;
  final AIAnalysis? aiAnalysis;
  final WoundSeverity severity;
  final String treatmentRecommendation;
  final bool requiresProfessional;
  final DateTime createdAt;
  
  const WoundAssessment({
    required this.id,
    required this.patientId,
    this.deviceId,
    required this.imageUrls,
    this.lidarData,
    this.aiAnalysis,
    required this.severity,
    required this.treatmentRecommendation,
    required this.requiresProfessional,
    required this.createdAt,
  });
  
  factory WoundAssessment.fromJson(Map<String, dynamic> json) {
    return WoundAssessment(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      deviceId: json['device_id'] as String?,
      imageUrls: List<String>.from(json['images'] ?? []),
      lidarData: json['lidar_data'] as Map<String, dynamic>?,
      aiAnalysis: json['ai_analysis'] != null 
          ? AIAnalysis.fromJson(json['ai_analysis'] as Map<String, dynamic>)
          : null,
      severity: WoundSeverity.values.firstWhere(
        (severity) => severity.name == json['severity_score'].toString(),
        orElse: () => WoundSeverity.minor,
      ),
      treatmentRecommendation: json['treatment_recommendation'] as String,
      requiresProfessional: json['requires_professional'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'device_id': deviceId,
      'images': imageUrls,
      'lidar_data': lidarData,
      'ai_analysis': aiAnalysis?.toJson(),
      'severity_score': severity.name,
      'treatment_recommendation': treatmentRecommendation,
      'requires_professional': requiresProfessional,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AIAnalysis {
  final double confidenceScore;
  final Map<String, dynamic> detectedFeatures;
  final List<String> recommendations;
  final double woundAreaCm2;
  final String? riskAssessment;
  
  const AIAnalysis({
    required this.confidenceScore,
    required this.detectedFeatures,
    required this.recommendations,
    required this.woundAreaCm2,
    this.riskAssessment,
  });
  
  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      detectedFeatures: json['detected_features'] as Map<String, dynamic>,
      recommendations: List<String>.from(json['recommendations'] ?? []),
      woundAreaCm2: (json['wound_area_cm2'] as num).toDouble(),
      riskAssessment: json['risk_assessment'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'confidence_score': confidenceScore,
      'detected_features': detectedFeatures,
      'recommendations': recommendations,
      'wound_area_cm2': woundAreaCm2,
      'risk_assessment': riskAssessment,
    };
  }
}

class VideoSession {
  final String id;
  final String patientId;
  final String providerId;
  final String? assessmentId;
  final VideoSessionStatus status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? recordingUrl;
  
  const VideoSession({
    required this.id,
    required this.patientId,
    required this.providerId,
    this.assessmentId,
    required this.status,
    this.startedAt,
    this.endedAt,
    this.recordingUrl,
  });
  
  factory VideoSession.fromJson(Map<String, dynamic> json) {
    return VideoSession(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      providerId: json['provider_id'] as String,
      assessmentId: json['assessment_id'] as String?,
      status: VideoSessionStatus.values.firstWhere(
        (status) => status.name == json['session_status'],
        orElse: () => VideoSessionStatus.pending,
      ),
      startedAt: json['started_at'] != null 
          ? DateTime.parse(json['started_at'] as String)
          : null,
      endedAt: json['ended_at'] != null 
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      recordingUrl: json['recording_url'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'provider_id': providerId,
      'assessment_id': assessmentId,
      'session_status': status.name,
      'started_at': startedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'recording_url': recordingUrl,
    };
  }
}

enum VideoSessionStatus { pending, active, completed, cancelled }
