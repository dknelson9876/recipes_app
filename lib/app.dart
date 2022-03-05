import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'package:recipes_app/ui/screens/login.dart';
import 'package:recipes_app/ui/theme.dart';

import 'package:recipes_app/ui/screens/home.dart';

class RecipesApp extends StatelessWidget {
  const RecipesApp({Key? key}) : super(key: key);

  final ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      theme: buildTheme(),
      themeMode: themeMode,
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        // '/signIn': (context) => const SignInPage(),
      },
    );
  }
}
