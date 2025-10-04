enum UserType { patient, healthcareProvider }

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final UserType userType;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      userType: UserType.values.firstWhere(
        (type) => type.name == json['user_type'],
        orElse: () => UserType.patient,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'user_type': userType.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    UserType? userType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
