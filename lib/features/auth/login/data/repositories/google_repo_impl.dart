import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/google_repo_base.dart';
import '../data_sources/firestore_service/firestore_service.dart';
import '../data_sources/google_sign_in/google_sign_in.dart';
import '../data_sources/remote_data_source/remote_data_source.dart';
import '../models/user.dart';

class GoogleRepositoryImpl implements GoogleRepositoryBase {
  final DSGoogleSignIn _dsGoogleSignIn;
  final FirestoreService _firestoreService;
  final DSAuthLocal _dsAuthLocal;

  GoogleRepositoryImpl(
      this._dsGoogleSignIn, this._firestoreService, this._dsAuthLocal);

  @override
  Future<UserModel?> signInWithGoogle() async {
    final user = await _dsGoogleSignIn.signInWithGoogle();
    if (user != null) {
      String phone = user.phoneNumber ?? '';
      if (phone.isEmpty) {
        phone = await _promptForPhoneNumber();
      }

      await _firestoreService.saveUserToFirestore(user, phone);

      final userModel = UserModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        phoneNumber: phone,
      );

      await _dsAuthLocal.saveDataToLocal(userModel);

      return userModel;
    }
    return null;
  }

  @override
  Future<void> signOutGoogle() async {
    await _dsGoogleSignIn.signOutGoogle();
    await FirebaseAuth.instance.signOut();
  }

  Future<String> _promptForPhoneNumber() async {
    // In a real app, you'd prompt the user for their phone number
    return 'missing phone number';
  }
}

final googleRepositoryProvider = Provider<GoogleRepositoryBase>((ref) {
  final googleSignInService = GoogleSignInServiceImpl();
  final firestoreService = FirestoreService();
  return GoogleRepositoryImpl(
      googleSignInService, firestoreService, DSAuthLocalImpl());
});
