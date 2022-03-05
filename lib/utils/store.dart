import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> updateFavorites(String uid, String recipeID) {
  DocumentReference favoritesReference =
      FirebaseFirestore.instance.collection('users').doc(uid);

  return FirebaseFirestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(favoritesReference);
    if (postSnapshot.exists) {
      //extend 'favorites' if the list does not contain the recipe id:
      if (!postSnapshot.get('favorites').contains(recipeID)) {
        tx.update(favoritesReference, <String, dynamic>{
          'favorites': FieldValue.arrayUnion([recipeID])
        });
        //Delete the recipe ID from 'favorites'
      } else {
        tx.update(favoritesReference, <String, dynamic>{
          'favorites': FieldValue.arrayRemove([recipeID])
        });
      }
    } else {
      //create a document for the current user in collection 'users'
      // and add a new array 'favorites' to the document
      tx.set(favoritesReference, {
        'favorites': [recipeID]
      });
    }
  }).then((result) {
    return true;
  }).catchError((error) {
    print('Error: $error');
    return false;
  });
}
