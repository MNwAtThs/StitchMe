import 'dart:async';
import 'package:flutter/services.dart';

class IosLidar {
  static const MethodChannel _channel = MethodChannel('stitchme/lidar');

  /// Check if LiDAR is available on the current device
  static Future<bool> get isLiDARAvailable async {
    final bool isAvailable = await _channel.invokeMethod('isLiDARAvailable');
    return isAvailable;
  }

  /// Start LiDAR scanning session
  static Future<Map<String, dynamic>?> startScanning() async {
    try {
      final result = await _channel.invokeMethod('startScanning');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to start LiDAR scanning: '${e.message}'.");
      return null;
    }
  }

  /// Stop LiDAR scanning session
  static Future<Map<String, dynamic>?> stopScanning() async {
    try {
      final result = await _channel.invokeMethod('stopScanning');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to stop LiDAR scanning: '${e.message}'.");
      return null;
    }
  }

  /// Capture current depth data from LiDAR
  static Future<List<Map<String, dynamic>>> captureData() async {
    try {
      final result = await _channel.invokeMethod('captureData');
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      print("Failed to capture LiDAR data: $e");
      return [];
    }
  }
}


