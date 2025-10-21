import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class PlatformUtils {
  // Basic platform checks
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb && (isAndroid || isIOS);
  static bool get isDesktop => !kIsWeb && (isWindows || isMacOS || isLinux);
  
  // Specific platform checks
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  
  // Get platform name
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
  
  // Check if device supports LiDAR (only certain iOS devices)
  static bool get supportsLiDAR {
    // Only iOS devices with LiDAR (iPhone 12 Pro and newer, iPad Pro 2020+)
    // This would need more sophisticated device detection in a real app
    return isIOS;
  }
  
  // Check if device supports Bluetooth
  static bool get supportsBluetooth {
    return isMobile || isDesktop; // Web has limited Bluetooth support
  }
  
  // Get appropriate screen layout
  static bool get useTabletLayout {
    // This would typically check screen size, but for simplicity:
    return isDesktop || (isMobile && false); // Add tablet detection logic
  }
}

// Example usage in widgets:
// import 'package:flutter/material.dart';
// 
// class PlatformAwareWidget extends StatelessWidget {
//   const PlatformAwareWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     if (PlatformUtils.isWeb) {
//       return const Text('This is the web version');
//     } else if (PlatformUtils.isMobile) {
//       return const Text('This is the mobile version');
//     } else if (PlatformUtils.isDesktop) {
//       return const Text('This is the desktop version');
//     } else {
//       return const Text('Unknown platform');
//     }
//   }
// }
