import 'package:flutter/material.dart';

const colorList = <Color>[
  Colors.blue,
  Colors.orange,
  Colors.deepPurple,
  Colors.purple,
  Colors.green,
  Colors.teal,
  Colors.blue,
  Colors.pink,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0 && selectedColor < colorList.length,
            'selectedColor must be positive and less or equal than ${colorList.length}');

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: colorList[selectedColor],
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
