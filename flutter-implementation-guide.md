# StitchMe Flutter Implementation Guide

## 🚀 **Quick Start - Flutter Setup**

### **1. Flutter Environment Setup (Day 1)**

```bash
# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor

# Install required tools
flutter doctor --android-licenses  # Accept Android licenses
```

### **2. Project Initialization**

```bash
# Create Flutter project
flutter create stitchme_app --platforms=ios,android,web,windows,macos,linux
cd stitchme_app

# Add essential dependencies
flutter pub add supabase_flutter
flutter pub add provider
flutter pub add go_router
flutter pub add camera
flutter pub add permission_handler
flutter pub add flutter_webrtc
flutter pub add bluetooth_low_energy
flutter pub add shared_preferences
flutter pub add http
flutter pub add image_picker
flutter pub add flutter_riverpod  # State management
```

### **3. Core Dependencies (pubspec.yaml)**

```yaml
name: stitchme_app
description: AI-powered wound assessment and treatment device controller

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  
  # Backend & Database
  supabase_flutter: ^2.0.0
  http: ^1.1.0
  
  # Navigation
  go_router: ^12.1.3
  
  # Camera & Media
  camera: ^0.10.5+5
  image_picker: ^1.0.4
  video_player: ^2.8.1
  
  # Device Communication
  flutter_bluetooth_serial: ^0.4.0
  wifi_iot: ^0.3.18+1
  permission_handler: ^11.1.0
  
  # Video Calling
  flutter_webrtc: ^0.9.47
  
  # UI & Animations
  flutter_animate: ^4.2.0+1
  lottie: ^2.7.0
  
  # Storage & Preferences
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  
  # Utilities
  uuid: ^4.2.1
  intl: ^0.18.1
  
  # Platform-specific
  arkit_plugin: ^0.11.0  # iOS ARKit integration
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.7
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1
```

---

## 📱 **Project Structure Setup**

### **Main App Structure**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  
  runApp(const ProviderScope(child: StitchMeApp()));
}

class StitchMeApp extends ConsumerWidget {
  const StitchMeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'StitchMe',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### **Feature-Based Architecture**

```dart
// lib/features/auth/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.initial());
  
  final _supabase = Supabase.instance.client;
  
  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState.loading();
    
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        state = AuthState.authenticated(response.user!);
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
  
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserType userType,
  }) async {
    state = const AuthState.loading();
    
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'user_type': userType.name,
        },
      );
      
      if (response.user != null) {
        state = AuthState.authenticated(response.user!);
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
  
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    state = const AuthState.initial();
  }
}

// Auth state classes
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}

enum UserType { patient, healthcareProvider }
```

---

## 📷 **Camera & LiDAR Integration**

### **Camera Service**

```dart
// lib/features/wound_scanning/services/camera_service.dart
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class CameraService {
  static const MethodChannel _lidarChannel = MethodChannel('stitchme/lidar');
  
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  
  Future<void> initialize() async {
    _cameras = await availableCameras();
    
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      
      await _controller!.initialize();
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
  
  // LiDAR Integration
  Future<Map<String, dynamic>?> startLiDARScanning() async {
    try {
      final result = await _lidarChannel.invokeMethod('startScanning');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to start LiDAR scanning: '${e.message}'.");
      return null;
    }
  }
  
  Future<List<Map<String, dynamic>>> captureLiDARData() async {
    try {
      final result = await _lidarChannel.invokeMethod('captureData');
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      print("Failed to capture LiDAR data: $e");
      return [];
    }
  }
  
  void dispose() {
    _controller?.dispose();
  }
}
```

### **Wound Scanning Screen**

```dart
// lib/features/wound_scanning/screens/wound_scanning_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

class WoundScanningScreen extends ConsumerStatefulWidget {
  const WoundScanningScreen({super.key});

  @override
  ConsumerState<WoundScanningScreen> createState() => _WoundScanningScreenState();
}

class _WoundScanningScreenState extends ConsumerState<WoundScanningScreen> {
  final CameraService _cameraService = CameraService();
  bool _isLiDARActive = false;
  bool _isProcessing = false;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  
  Future<void> _initializeCamera() async {
    await _cameraService.initialize();
    setState(() {});
  }
  
  Future<void> _captureAndAnalyze() async {
    setState(() => _isProcessing = true);
    
    try {
      // Capture regular image
      final image = await _cameraService.captureImage();
      
      // Capture LiDAR data if available
      List<Map<String, dynamic>> lidarData = [];
      if (_isLiDARActive) {
        lidarData = await _cameraService.captureLiDARData();
      }
      
      if (image != null) {
        // Send to AI service for analysis
        final analysisResult = await ref
            .read(woundAnalysisProvider.notifier)
            .analyzeWound(image, lidarData);
        
        // Navigate to results screen
        if (mounted) {
          // Handle navigation to results
        }
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }
  
  Future<void> _toggleLiDAR() async {
    if (!_isLiDARActive) {
      final result = await _cameraService.startLiDARScanning();
      if (result != null && result['status'] == 'started') {
        setState(() => _isLiDARActive = true);
      }
    } else {
      setState(() => _isLiDARActive = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wound Scanning'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Camera Preview
          if (_cameraService._controller?.value.isInitialized == true)
            Positioned.fill(
              child: CameraPreview(_cameraService._controller!),
            ),
          
          // LiDAR Overlay
          if (_isLiDARActive)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'LiDAR Active',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          
          // Controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // LiDAR Toggle
                FloatingActionButton(
                  onPressed: _toggleLiDAR,
                  backgroundColor: _isLiDARActive ? Colors.blue : Colors.grey,
                  child: const Icon(Icons.threed_rotation),
                ),
                
                // Capture Button
                FloatingActionButton.large(
                  onPressed: _isProcessing ? null : _captureAndAnalyze,
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.camera_alt),
                ),
                
                // Gallery
                FloatingActionButton(
                  onPressed: () {
                    // Navigate to gallery
                  },
                  child: const Icon(Icons.photo_library),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}
```

---

## 🎥 **Video Calling Integration**

### **WebRTC Service**

```dart
// lib/features/video_calling/services/webrtc_service.dart
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  
  final List<RTCIceServer> _iceServers = [
    RTCIceServer(url: 'stun:stun.l.google.com:19302'),
  ];
  
  Future<void> initialize() async {
    // Get user media
    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });
    
    // Create peer connection
    _peerConnection = await createPeerConnection({
      'iceServers': _iceServers,
    });
    
    // Add local stream
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });
    
    // Handle remote stream
    _peerConnection!.onAddStream = (stream) {
      _remoteStream = stream;
      // Notify UI about remote stream
    };
  }
  
  Future<RTCSessionDescription> createOffer() async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    return offer;
  }
  
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    await _peerConnection!.setRemoteDescription(description);
  }
  
  Future<RTCSessionDescription> createAnswer() async {
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    return answer;
  }
  
  void dispose() {
    _localStream?.dispose();
    _remoteStream?.dispose();
    _peerConnection?.dispose();
  }
}
```

---

## 🔧 **Development Workflow**

### **Getting Started Commands**

```bash
# 1. Clone and setup
git clone <your-repo>
cd StitchMe/apps/flutter_app

# 2. Install dependencies
flutter pub get

# 3. Generate code (for json_serializable, etc.)
flutter packages pub run build_runner build

# 4. Run on different platforms
flutter run -d chrome          # Web
flutter run -d macos           # macOS desktop
flutter run -d ios             # iOS simulator
flutter run -d android         # Android emulator

# 5. Build for production
flutter build web              # Web build
flutter build ios             # iOS build
flutter build apk             # Android APK
flutter build windows         # Windows executable
```

### **Platform-Specific Setup**

#### **iOS Setup (for LiDAR)**
```bash
cd ios
pod install
```

Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for wound scanning</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for video calls</string>
```

#### **Android Setup**
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

---

## 🎯 **Flutter-Specific Advantages for StitchMe**

### **1. Single Codebase Benefits**
- ✅ **Mobile + Desktop + Web** from one codebase
- ✅ **Consistent UI/UX** across all platforms
- ✅ **Shared business logic** and state management
- ✅ **Faster development** once team is up to speed

### **2. Medical UI Excellence**
- ✅ **Custom widgets** for medical interfaces
- ✅ **Precise animations** for device pairing
- ✅ **Professional themes** with Material Design 3
- ✅ **Accessibility** built-in

### **3. Performance Benefits**
- ✅ **Compiled to native code** (better than web-based solutions)
- ✅ **60fps animations** for smooth user experience
- ✅ **Efficient memory usage** for AI processing
- ✅ **Fast startup times**

### **4. Development Productivity**
- ✅ **Hot reload** for instant feedback
- ✅ **Excellent tooling** (Flutter Inspector, DevTools)
- ✅ **Strong typing** with Dart
- ✅ **Great testing framework**

---

## 📋 **Week 1 Action Items (Flutter)**

### **Day 1-2: Environment Setup**
- [ ] Install Flutter SDK and verify with `flutter doctor`
- [ ] Set up IDE (VS Code with Flutter extension)
- [ ] Create Supabase project and get credentials
- [ ] Initialize Flutter project with all platforms

### **Day 3-4: Basic Structure**
- [ ] Set up project structure with feature-based architecture
- [ ] Implement basic authentication with Supabase
- [ ] Create navigation structure with go_router
- [ ] Set up state management with Riverpod

### **Day 5-7: UI Foundation**
- [ ] Create design system and theme
- [ ] Build basic screens (login, dashboard, profile)
- [ ] Implement responsive layouts
- [ ] Test on multiple platforms (mobile, web, desktop)

This Flutter implementation will give you a solid foundation for your StitchMe project with excellent cross-platform capabilities!
