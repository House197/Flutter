import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;
  final int selectedColor;

  AppTheme({this.isDarkMode = true, this.selectedColor = 0});

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: const Color(0xFF2862F5),
      );
}
