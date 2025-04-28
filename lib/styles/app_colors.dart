import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF003453); // Deep Blue
  static const Color secondaryColor = Color(0xFFCCAB4F); // Gold

  // Backgrounds
  static const Color backgroundColor = Color(0xFFFFFFFF); // White
  static const Color surfaceColor =
      Color(0xFFFFFFFF); // White (same as background for now)

  // Text Colors
  static const Color primaryTextColor = Color(0xFF000000); // Black
  static const Color secondaryTextColor = Color(0xFF757575); // Grey

  // Error Colors
  static const Color errorColor =
      Color(0xFFFF3B30); // iOS-style Red (or you can keep Colors.red)

  // Optional: Success, Warning, Info
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color warningColor = Color(0xFFFFA000); // Amber (Darker)
  static const Color infoColor = Color(0xFF29B6F6); // Light Blue
}
