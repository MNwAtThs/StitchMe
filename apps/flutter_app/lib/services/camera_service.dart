import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class CameraService {
  static const MethodChannel _lidarChannel = MethodChannel('stitchme/lidar');
  
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  
  bool get isInitialized => _isInitialized;
  CameraController? get controller => _controller;
  
  Future<void> initialize() async {
    try {
      print('Getting available cameras...');
      _cameras = await availableCameras();
      print('Found ${_cameras!.length} cameras');
      
      if (_cameras!.isNotEmpty) {
        // Use back camera for wound scanning
        final backCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
        );
        
        print('Initializing camera controller...');
        _controller = CameraController(
          backCamera,
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        
        await _controller!.initialize();
        _isInitialized = true;
        print('Camera controller initialized successfully');
      } else {
        print('No cameras found');
        _isInitialized = false;
      }
    } catch (e) {
      print('Error initializing camera: $e');
      _isInitialized = false;
      rethrow; // Re-throw to get more specific error info
    }
  }

  /// Try to initialize camera directly without permission check
  Future<bool> tryDirectInitialize() async {
    try {
      print('Attempting direct camera initialization...');
      await initialize();
      return _isInitialized;
    } catch (e) {
      print('Direct camera initialization failed: $e');
      return false;
    }
  }
  
  Future<XFile?> captureImage() async {
    if (_controller?.value.isInitialized != true) return null;
    
    try {
      return await _controller!.takePicture();
    } catch (e) {
      print('Error capturing image: $e');
      return null;
    }
  }
  
  // LiDAR Integration (iOS only)
  Future<bool> isLiDARAvailable() async {
    if (!Platform.isIOS) return false;
    
    try {
      final result = await _lidarChannel.invokeMethod('isLiDARAvailable');
      return result as bool;
    } on PlatformException catch (e) {
      print("Failed to check LiDAR availability: '${e.message}'.");
      return false;
    } on MissingPluginException catch (e) {
      print("LiDAR plugin not implemented: '${e.message}'. LiDAR features will be disabled.");
      return false;
    } catch (e) {
      print("Unexpected error checking LiDAR availability: $e");
      return false;
    }
  }
  
  Future<Map<String, dynamic>?> startLiDARScanning() async {
    try {
      final result = await _lidarChannel.invokeMethod('startScanning');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to start LiDAR scanning: '${e.message}'.");
      return null;
    } on MissingPluginException catch (e) {
      print("LiDAR plugin not implemented: '${e.message}'. Skipping LiDAR scanning.");
      return null;
    }
  }
  
  Future<List<Map<String, dynamic>>> captureLiDARData() async {
    try {
      final result = await _lidarChannel.invokeMethod('captureData');
      return List<Map<String, dynamic>>.from(result);
    } on MissingPluginException catch (e) {
      print("LiDAR plugin not implemented: '${e.message}'. Returning empty data.");
      return [];
    } catch (e) {
      print("Failed to capture LiDAR data: $e");
      return [];
    }
  }
  
  Future<void> stopLiDARScanning() async {
    try {
      await _lidarChannel.invokeMethod('stopScanning');
    } on PlatformException catch (e) {
      print("Failed to stop LiDAR scanning: '${e.message}'.");
    } on MissingPluginException catch (e) {
      print("LiDAR plugin not implemented: '${e.message}'. Nothing to stop.");
    }
  }
  
  void dispose() {
    _controller?.dispose();
    _isInitialized = false;
  }
}


