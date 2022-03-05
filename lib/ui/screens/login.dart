import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/services/firebase_service.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:recipes_app/state_widget.dart';
import 'package:recipes_app/ui/widgets/google_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;

    BoxDecoration _buildBackground() {
      return const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/login-background.jpg"),
          fit: BoxFit.cover,
        ),
      );
    }

    Text _buildText() {
      return Text(
        'Recipes',
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      );
    }

    return Scaffold(
      body: Container(
        decoration: _buildBackground(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildText(),
              const SizedBox(height: 50.0),
              GoogleSignInButton(
                onPressed: () =>
                    context.read<FirebaseService>().signInWithGoogle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
