import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<GoogleSignInAccount> getSignedInAccount(
    GoogleSignIn googleSignIn) async {
  //is the user already signed in?
  GoogleSignInAccount account = googleSignIn.currentUser;
  //try to sign in the previous user
  if (account == null) {
    account = await googleSignIn.signInSilently();
  }
  return account;
}

Future<UserCredential> signIntoFirebase(
  //   GoogleSignInAccount googleSignInAccount) async {
  // FirebaseAuth _auth = FirebaseAuth.instance;
  // GoogleSignInAuthentication googleAuth =
  //     await googleSignInAccount.authentication;
  // final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
  // AuthResult result = await _auth.signInWithCredential(credential);

  // return result.user;

  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken,);

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
