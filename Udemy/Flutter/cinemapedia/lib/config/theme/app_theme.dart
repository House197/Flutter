import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;
  final int selectedColor;

  AppTheme({this.isDarkMode = false, this.selectedColor = 0});

  ThemeData getTheme() => ThemeData(
        useMaterial3: false,
        colorSchemeSeed: const Color(0xFF2862F5),
      );
}
