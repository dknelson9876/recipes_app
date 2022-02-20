import 'package:flutter/material.dart';

ThemeData buildTheme() {
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline2: base.headline2?.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 40.0,
        color: const Color(0xFF807A6B),
      ),
      headline4: base.headline4?.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 15.0,
        color: const Color(0xFF807A6B),
      ),
      caption: base.caption?.copyWith(
        color: const Color(0xFFCCC5AF),
      ),
    );
  }

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryColor: const Color(0xFFFFF8E1),
    indicatorColor: const Color(0xFF807A6B),
    scaffoldBackgroundColor: const Color(0XFFF5F5F5),
    accentColor: const Color(0xFFFFF8E1),
    iconTheme: const IconThemeData(
      color: Color(0xFFCCC5AF),
      size: 20.0,
    ),
    buttonColor: Colors.white,
  );
}
