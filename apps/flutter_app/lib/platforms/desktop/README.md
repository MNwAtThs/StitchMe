# Desktop Onboarding

This directory contains the desktop-specific onboarding experience for Windows, macOS, and Linux platforms.

## Features

The desktop onboarding appears as a modal popup window that explains the StitchMe app:

1. **Welcome Screen** - Introduction to StitchMe with key features overview
2. **AI Analysis Screen** - Explains AI-powered wound analysis capabilities
3. **LiDAR Scanning Screen** - Details 3D scanning functionality
4. **Telemedicine Screen** - Shows video calling and healthcare provider integration
5. **Device Management Screen** - Explains device control and patient management

## Implementation

- **DesktopOnboarding**: Main dialog widget with page view navigation
- **Individual Step Widgets**: Each screen is a separate widget for maintainability
- **DesktopOnboardingWrapper**: Wrapper that shows login screen with popup overlay
- **Platform Detection**: Automatically detects desktop platforms (Windows/macOS/Linux)

## Key Differences from Mobile

### **UI Design**
- **Modal Dialog**: 600x500px popup window instead of full screen
- **Header Bar**: Blue header with close button and step counter
- **Progress Bar**: Visual progress indicator below header
- **Footer Navigation**: Bottom navigation with step dots and buttons
- **Compact Layout**: Optimized for desktop screen real estate

### **Navigation**
- **Step Indicators**: Dots showing current progress
- **Back/Next Buttons**: Standard desktop navigation pattern
- **Close Button**: X button in header to skip onboarding
- **Non-dismissible**: Can't click outside to close (must complete or skip)

### **Content Adaptation**
- **Healthcare Professional Focus**: Emphasizes device management and patient care
- **Desktop-Specific Features**: Highlights multi-device control capabilities
- **Compact Text**: Shorter descriptions optimized for popup format
- **Professional Styling**: More business-oriented design language

## Usage

The desktop onboarding automatically appears for first-time users on desktop platforms:
- Shows as a modal popup over the login screen
- Users can navigate through all steps or skip entirely
- Completion saves state and closes the popup
- Subsequent launches go directly to login screen

## Testing

To test the desktop onboarding flow:
1. Use the "Reset Onboarding" option in the dashboard menu
2. Or clear app data and reinstall
3. The onboarding popup will appear on the next app launch

## Platform Support

- **Windows**: Full support with native dialog behavior
- **macOS**: Full support with native dialog behavior  
- **Linux**: Full support with native dialog behavior
- **Web**: Not applicable (shows homepage instead)

## Customization

Each step can be easily customized by modifying the individual step widgets:
- `DesktopWelcomeStep`
- `DesktopAIAnalysisStep`
- `DesktopLiDARStep`
- `DesktopTelemedicineStep`
- `DesktopDevicePairingStep`
