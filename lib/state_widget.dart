import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:recipes_app/model/state.dart';
import 'package:recipes_app/services/firebase_service.dart';

class StateWidget extends StatefulWidget {
  final StateModel? state;
  final Widget child;

  const StateWidget({
    Key? key,
    required this.child,
    this.state,
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
  StateModel? state;
  User? googleAccount;
  FirebaseService? service;

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

  Future<void> initUser() async {
    //opens sign in dialog on start. need to move it to button onpressed
    service = FirebaseService();
    googleAccount = await service?.getSignedInAccount();

    if (googleAccount == null) {
      //if no previous account exists, stop trying to load it so that the login screen shows
      setState(() {
        state?.isLoading = false;
      });
    } else {
      //if there is a previous account, load it and then stop loading so that the home screen shows
      await signInWithGoogle();
    }
  }

  Future<void> signInWithGoogle() async {
    googleAccount = await service?.signInWithGoogle();
    setState(() {
      state?.isLoading = false;
      state?.user = googleAccount;
    });
  }

  Future<void> signOutOfGoogle() async {
    await service?.signOutFromGoogle();
    googleAccount = null;
    state?.user = null;
    setState(() {
      state = StateModel(user: null);
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
