# Mobile Onboarding

This directory contains the mobile-specific onboarding experience for iOS and Android platforms.

## Features

The onboarding flow includes 5 comprehensive screens that explain the StitchMe app:

1. **Welcome Screen** - Introduction to StitchMe and key benefits
2. **AI Analysis Screen** - Explains the AI-powered wound analysis capabilities
3. **LiDAR Scanning Screen** - Details the 3D scanning functionality using iPhone LiDAR
4. **Telemedicine Screen** - Shows video calling and healthcare provider integration
5. **Device Pairing Screen** - Explains how to connect with the physical StitchMe device

## Implementation

- **OnboardingScreen**: Main widget that manages the page view and navigation
- **Individual Page Widgets**: Each screen is a separate widget for maintainability
- **OnboardingUtils**: Utility class for managing onboarding state with SharedPreferences
- **Platform Detection**: Only shows on mobile platforms (iOS/Android), web shows homepage

## Usage

The onboarding automatically appears for first-time users on mobile platforms. Users can:
- Navigate through screens with Next/Back buttons
- Skip the entire onboarding process
- Complete onboarding to proceed to the login screen

## Testing

To test the onboarding flow:
1. Use the "Reset Onboarding" option in the dashboard menu
2. Or clear app data and reinstall
3. The onboarding will appear on the next app launch

## Customization

Each screen can be easily customized by modifying the individual page widgets:
- `WelcomePage`
- `AIAnalysisPage` 
- `LiDARScanningPage`
- `TelemedicinePage`
- `DevicePairingPage`
