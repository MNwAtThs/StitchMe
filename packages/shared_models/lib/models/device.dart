enum DeviceStatus { offline, online, connecting, error }

enum DeviceType { stitchmeDevice, mobilePhone, tablet, desktop }

class DeviceModel {
  final String id;
  final String deviceName;
  final DeviceType deviceType;
  final String? ownerId;
  final DeviceStatus status;
  final DateTime? lastSeen;
  final Map<String, dynamic>? configuration;
  final DateTime createdAt;
  
  const DeviceModel({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    this.ownerId,
    required this.status,
    this.lastSeen,
    this.configuration,
    required this.createdAt,
  });
  
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      deviceName: json['device_name'] as String,
      deviceType: DeviceType.values.firstWhere(
        (type) => type.name == json['device_type'],
        orElse: () => DeviceType.stitchmeDevice,
      ),
      ownerId: json['owner_id'] as String?,
      status: DeviceStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => DeviceStatus.offline,
      ),
      lastSeen: json['last_seen'] != null 
          ? DateTime.parse(json['last_seen'] as String)
          : null,
      configuration: json['configuration'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_name': deviceName,
      'device_type': deviceType.name,
      'owner_id': ownerId,
      'status': status.name,
      'last_seen': lastSeen?.toIso8601String(),
      'configuration': configuration,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  DeviceModel copyWith({
    String? id,
    String? deviceName,
    DeviceType? deviceType,
    String? ownerId,
    DeviceStatus? status,
    DateTime? lastSeen,
    Map<String, dynamic>? configuration,
    DateTime? createdAt,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      configuration: configuration ?? this.configuration,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
