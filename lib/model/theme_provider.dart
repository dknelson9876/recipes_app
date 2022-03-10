import 'package:flex_color_scheme/src/flex_scheme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode newMode) {
    _themeMode = newMode;
    notifyListeners();
  }

  FlexScheme _colorScheme = FlexScheme.jungle;
  FlexScheme get colorScheme => _colorScheme;
  set colorScheme(FlexScheme newScheme) {
    _colorScheme = newScheme;
    notifyListeners();
  }
}
