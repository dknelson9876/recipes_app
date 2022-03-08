import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes_app/main.dart';
import 'package:path/path.dart' as path;

class FirebaseService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  bool isLoading = true;
  List<String> favorites = [];
  final CollectionReference _recipes =
      FirebaseFirestore.instance.collection('recipes');
  FirebaseStorage storage = FirebaseStorage.instance;

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
      user = await signInWithGooglePopup();
      favorites = await getFavorites();
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    user = await signInWithGooglePopup();
    favorites = await getFavorites();
    isLoading = false;
    notifyListeners();
  }

  Future<User?> signInWithGooglePopup() async {
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
      // notifyListeners();
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

  Future<String> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
      );

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        //uploading the selected iamge with some custom meta data
        await storage.ref(fileName).putFile(imageFile);

        return storage.ref(fileName).getDownloadURL();
      } on FirebaseException catch (error) {
        // if (kDebugMode) {
        //   print(error);
        // }
        snackbarKey.currentState?.showSnackBar(const SnackBar(
          content: Text('There was a problem uploading your image'),
        ));
        return '';
      }
    } catch (err) {
      // if (kDebugMode) {
      //   print(err);
      // }
      snackbarKey.currentState?.showSnackBar(const SnackBar(
        content: Text('There was a problem uploading your image'),
      ));
      return '';
    }
  }
}
