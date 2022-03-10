import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/main.dart';
import 'package:recipes_app/model/theme_provider.dart';
import 'package:recipes_app/services/firebase_service.dart';

import 'package:recipes_app/ui/screens/login.dart';
import 'package:recipes_app/ui/screens/new_recipe.dart';
import 'package:recipes_app/ui/theme.dart';

import 'package:recipes_app/ui/screens/home.dart';

class RecipesApp extends StatelessWidget {
  const RecipesApp({Key? key}) : super(key: key);

  // final ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseService>(
            create: (context) => FirebaseService()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Recipes',
          theme: buildTheme(context),
          themeMode: context.watch<ThemeProvider>().themeMode,
          scaffoldMessengerKey: snackbarKey,
          routes: {
            '/': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/newRecipe': (context) => const NewRecipeScreen(),
            // '/signIn': (context) => const SignInPage(),
          },
        );
      },
    );
  }
}
