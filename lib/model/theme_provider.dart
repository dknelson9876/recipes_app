import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void set themeMode(ThemeMode newMode) {
    _themeMode = newMode;
    notifyListeners();
  }
}
