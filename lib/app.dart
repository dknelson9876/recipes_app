import 'package:flutter/material.dart';

import 'package:recipes_app/ui/screens/login.dart';
import 'package:recipes_app/ui/theme.dart';

import 'package:recipes_app/ui/screens/home.dart';

class RecipesApp extends StatelessWidget {
  const RecipesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      theme: buildTheme(),
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
