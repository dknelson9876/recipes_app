import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/main.dart';

class FirebaseService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  bool isLoading = true;
  late List<String> favorites;
  final CollectionReference _recipes =
      FirebaseFirestore.instance.collection('recipes');

  FirebaseService() {
    initUser();
  }

  Future<void> initUser() async {
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      //if no previous login exists, stop trying to load so that
      // the login screen shows
      isLoading = false;
    } else {
      //if there is a previous login, load it then stop loading so that
      // the home screen shows
      user = await signInWithGoogle();
      favorites = await getFavorites();
      isLoading = false;
    }
    notifyListeners();
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await _auth.signInWithCredential(credential);
      notifyListeners();
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    user = null;
    notifyListeners();
  }

  //this should be replaced by the Provider in some fashion
  // Future<User?> getSignedInAccount() async {
  //   User? result = FirebaseAuth.instance.currentUser;
  //   return result;
  // }

  Future<List<String>> getFavorites() async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (querySnapshot.exists && querySnapshot['favorites'] is List) {
      //Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot['favorites']);
    }
    return [];
  }

  Future<void> uploadRecipe(BuildContext context, Object recipe) async {
    await _recipes.add(recipe);

    // ScaffoldMessenger.of(context)
    //     .showSnackBar(const SnackBar(content: Text('Successfully uploaded')));
    snackbarKey.currentState
        ?.showSnackBar(const SnackBar(content: Text('Successfully uploaded')));
    notifyListeners();
  }

  Future<bool> updateFavorites(String recipeID) {
    DocumentReference favoritesReference =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(favoritesReference);
      if (postSnapshot.exists) {
        //extend 'favorites' if the list does not contain the recipe id:
        if (!postSnapshot.get('favorites').contains(recipeID)) {
          tx.update(favoritesReference, <String, dynamic>{
            'favorites': FieldValue.arrayUnion([recipeID])
          });
          favorites.add(recipeID);
          //Delete the recipe ID from 'favorites'
        } else {
          tx.update(favoritesReference, <String, dynamic>{
            'favorites': FieldValue.arrayRemove([recipeID])
          });
          favorites.remove(recipeID);
        }
      } else {
        //create a document for the current user in collection 'users'
        // and add a new array 'favorites' to the document
        tx.set(favoritesReference, {
          'favorites': [recipeID]
        });
      }
      notifyListeners();
    }).then((result) {
      notifyListeners();
      return true;
    }).catchError((error) {
      print('Error: $error');
      return false;
    });
  }
}
