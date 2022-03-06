import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

ThemeData buildTheme() {
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline2: base.headline2?.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 30.0,
        // color: base.headline6?.color,
      ),
      headline4: base.headline4?.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 15.0,
        // color: const Color(0xFF807A6B),
      ),
      caption: base.caption?.copyWith(
          // color: const Color(0xFFCCC5AF),
          ),
    );
  }

  final ThemeData base =
      FlexColorScheme.light(scheme: FlexScheme.jungle).toTheme;

  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    // primaryColor: const Color(0xFFFFF8E1),
    // indicatorColor: const Color(0xFF807A6B),
    // scaffoldBackgroundColor: const Color(0XFFF5F5F5),
    // accentColor: const Color(0xFFFFF8E1),
    iconTheme: const IconThemeData(
      // color: Color(0xFFCCC5AF),
      size: 20.0,
    ),
    // buttonColor: Colors.white,
    // backgroundColor: Colors.white,
    // tabBarTheme: base.tabBarTheme.copyWith(
    // labelColor: const Color(0xFF807A6B),
    // unselectedLabelColor: const Color(0xFFCCC5AF),
    // ),
  );
}
