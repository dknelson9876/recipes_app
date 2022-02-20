import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:recipes_app/model/state.dart';
import 'package:recipes_app/utils/auth.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    Key? key,
    required this.child,
    required this.state,
  }) : super(key: key);

  static _StateWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_StateDataWidget>()
            as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  late StateModel state;
  late GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);

    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      googleAccount = await googleSignIn.signIn();
    }
    FirebaseUser firebaseUser = await signIntoFirebase(googleAccount);
    setState(() {
      state.isLoading = false;
      state.user = firebaseUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}
