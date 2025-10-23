import 'package:flutter/material.dart';

/// StitchMe Design System - Single Source of Truth
/// Based on iOS/mobile platform styling
class AppTheme {
  // ========================================
  // COLOR PALETTE
  // ========================================
  
  // Primary Colors (iOS-inspired)
  static const Color primaryBlue = Color(0xFF007AFF); // iOS Blue - Main actions
  static const Color accentBlue = Color(0xFF2563EB); // Brand Blue - Icons, branding
  
  // Semantic Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color criticalRed = Color(0xFFDC2626);
  
  // Medical UI Colors
  static const Color medicalBlue = Color(0xFF1E40AF);
  static const Color medicalGreen = Color(0xFF059669);
  
  // Neutral Colors
  static const Color textPrimary = Color(0xFF000000); // Black
  static const Color textSecondary = Color(0xFF6B7280); // Gray
  static const Color backgroundPrimary = Color(0xFFFFFFFF); // White
  static const Color backgroundSecondary = Color(0xFFF2F2F7); // Light gray
  static const Color surfaceColor = Color(0xFFF2F2F7);
  static const Color borderDefault = Color(0xFFE5E7EB); // Light border
  
  // Additional accent colors (for variety)
  static const Color purpleAccent = Color(0xFF8B5CF6);
  
  // ========================================
  // TYPOGRAPHY
  // ========================================
  
  // Title Styles (Large, bold headings)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.3,
  );
  
  // Label Styles (for buttons, form fields)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );
  
  // Button Text Style
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  // ========================================
  // SPACING & DIMENSIONS
  // ========================================
  
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXl = 20.0;
  static const double spacingXxl = 24.0;
  static const double spacingXxxl = 32.0;
  static const double spacingHuge = 40.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusRound = 999.0;
  
  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 28.0;
  static const double iconXl = 40.0;
  static const double iconXxl = 50.0;
  
  // Button Heights
  static const double buttonHeightS = 40.0;
  static const double buttonHeightM = 50.0;
  static const double buttonHeightL = 56.0;
  
  // ========================================
  // THEME DATA
  // ========================================
  
  /// Light Theme (Primary theme)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentBlue,
        error: errorRed,
        surface: backgroundPrimary,
        brightness: Brightness.light,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: backgroundPrimary,
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, buttonHeightM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: buttonText,
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          textStyle: buttonText,
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 1.5),
          minimumSize: const Size(double.infinity, buttonHeightM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: buttonText,
        ),
      ),
      
      // Input Decoration (Forms)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingL,
        ),
        hintStyle: bodyLarge.copyWith(color: textSecondary.withOpacity(0.6)),
      ),
      
      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
        color: backgroundPrimary,
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
        backgroundColor: backgroundPrimary,
        elevation: 8,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: titleLarge,
        displayMedium: titleMedium,
        displaySmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: iconL,
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: textSecondary.withOpacity(0.2),
        thickness: 1,
        space: spacingL,
      ),
    );
  }
  
  /// Dark Theme
  static ThemeData get darkTheme {
    const darkBackground = Color(0xFF000000);
    const darkSurface = Color(0xFF1C1C1E);
    const darkTextPrimary = Color(0xFFFFFFFF);
    const darkTextSecondary = Color(0xFF8E8E93);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentBlue,
        error: errorRed,
        surface: darkSurface,
        brightness: Brightness.dark,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: darkBackground,
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, buttonHeightM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: buttonText,
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          textStyle: buttonText,
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 1.5),
          minimumSize: const Size(double.infinity, buttonHeightM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: buttonText,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingL,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          color: darkTextSecondary.withOpacity(0.6),
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
        color: darkSurface,
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
        backgroundColor: darkSurface,
        elevation: 8,
      ),
      
      // Text Theme (with dark colors)
      textTheme: TextTheme(
        displayLarge: titleLarge.copyWith(color: darkTextPrimary),
        displayMedium: titleMedium.copyWith(color: darkTextPrimary),
        displaySmall: titleSmall.copyWith(color: darkTextPrimary),
        bodyLarge: bodyLarge.copyWith(color: darkTextSecondary),
        bodyMedium: bodyMedium.copyWith(color: darkTextSecondary),
        bodySmall: bodySmall.copyWith(color: darkTextSecondary),
        labelLarge: labelLarge.copyWith(color: darkTextPrimary),
        labelMedium: labelMedium.copyWith(color: darkTextPrimary),
        labelSmall: labelSmall.copyWith(color: darkTextPrimary),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: darkTextPrimary,
        size: iconL,
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: darkTextSecondary.withOpacity(0.2),
        thickness: 1,
        space: spacingL,
      ),
    );
  }
  
  // ========================================
  // HELPER METHODS
  // ========================================
  
  /// Creates a container with brand styling
  static BoxDecoration brandContainer({
    Color? color,
    double? borderRadius,
  }) {
    return BoxDecoration(
      color: (color ?? accentBlue).withOpacity(0.1),
      borderRadius: BorderRadius.circular(borderRadius ?? radiusXl),
    );
  }
  
  /// Creates a surface container (cards, panels)
  static BoxDecoration surfaceContainer({
    Color? color,
    double? borderRadius,
    bool withBorder = false,
  }) {
    return BoxDecoration(
      color: color ?? surfaceColor,
      borderRadius: BorderRadius.circular(borderRadius ?? radiusM),
      border: withBorder
          ? Border.all(color: textSecondary.withOpacity(0.1), width: 1)
          : null,
    );
  }
  
  /// Creates an icon container (for onboarding, features, etc.)
  static Container iconContainer({
    required IconData icon,
    Color? iconColor,
    Color? backgroundColor,
    double? size,
  }) {
    final containerSize = size ?? 80.0;
    final iconSize = (containerSize * 0.5).clamp(iconXl, iconXxl);
    
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: brandContainer(
        color: backgroundColor ?? iconColor ?? accentBlue,
        borderRadius: radiusXl,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? accentBlue,
      ),
    );
  }
}
