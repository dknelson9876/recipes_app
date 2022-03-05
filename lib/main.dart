import 'package:flutter/material.dart';
import 'package:recipes_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:recipes_app/state_widget.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RecipesApp());
}
