import 'package:flutter/material.dart';
import 'package:recipes_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes_app/state_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StateWidget(
    child: RecipesApp(),
  ));
}
