import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipes_app/services/firebase-service.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OutlineInputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFFFFFFF),
        width: 3.0,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/sign-in.png"),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Sign in",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            GoogleSignIn(),
            buildRowDivider(size: size),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
            SizedBox(
              width: size.width * 0.8,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  enabledBorder: border,
                  focusedBorder: border,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              width: size.width * 0.8,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  enabledBorder: border,
                  focusedBorder: border,
                  suffixIcon: const Padding(
                    child: Icon(
                      Icons.abc,
                      size: 15,
                    ),
                    padding: EdgeInsets.only(top: 15.0, left: 15.0),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.05)),
            SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton(
                onPressed: () async {},
                child: const Text("sign in"),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).canvasColor),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
                ),
              ),
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: "create account",
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                  const TextSpan(
                      text: "sign up",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ])),
          ],
        ),
      ),
    );
  }

  Widget buildRowDivider({required Size size}) {
    return SizedBox(
        width: size.width * 0.8,
        child: Row(
          children: const [
            Expanded(child: Divider(color: Colors.black87)),
            Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                "Or",
                style: TextStyle(color: Colors.black12),
              ),
            ),
            Expanded(child: Divider(color: Colors.black87)),
          ],
        ));
  }
}

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !isLoading
        ? SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.google),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                FirebaseService service = new FirebaseService();
                try {
                  await service.signInWithGoogle();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    showMessage(e.message!);
                  }
                }
                setState(() {
                  isLoading = false;
                });
              },
              label: const Text(
                "Sign in with google",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
              ),
            ),
          )
        : const CircularProgressIndicator();
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
