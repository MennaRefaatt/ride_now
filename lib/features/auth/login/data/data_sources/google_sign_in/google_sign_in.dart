import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

abstract class DSGoogleSignIn {
  Future<User?> signInWithGoogle();
  Future<void> signOutGoogle();
}

class GoogleSignInServiceImpl implements DSGoogleSignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      safePrint("Error during Google sign-in: $e");
      return null;
    }
  }

  @override
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
