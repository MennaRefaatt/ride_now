import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

abstract class DSFacebookSignIn {
  Future<User?> signInWithFacebook();
  Future<void> signOutFacebook();
}

class DSFacebookSignInImpl implements DSFacebookSignIn {
  DSFacebookSignInImpl();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        return null;
      }
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      safePrint("Error during Facebook sign-in: $e");
      return null;
    }
  }

  @override
  Future<void> signOutFacebook() async {
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }
}
