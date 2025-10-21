import 'package:flutter/material.dart';

class Mycolors {
  static const Color primary = Color(0xFF2196F3); // Yellow button
  static const Color secondary = Color(0xFF00BCD4);
  static const Color background = Color(0xFFF5F5F5); // App background
  static const Color cardPanel = Color(0xFFFFFFFF); // White cards
  static const Color textPrimary = Color(0xFF1E1E1E); // Almost black
  static const Color textSecondary = Color(0xFF7D7D7D); // Muted grey
  static const Color accent = Color(0xFFB38BFA); // Purple tags
  static const Color success = Color(0xFFD9F2E4); // Light green
  static const Color error = Color(0xFFFCE8E6); // Light red/pink
}

class MyShadows {
  static const BoxShadow cardShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 8.0,
    offset: Offset(0, 4),
  );

  static const BoxShadow modalShadow = BoxShadow(
    color: Colors.black38,
    blurRadius: 16.0,
    offset: Offset(0, 8),
  );
}
