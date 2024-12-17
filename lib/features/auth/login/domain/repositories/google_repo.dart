import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/firestore_service/firestore_service.dart';
import '../../data/data_sources/google_sign_in/google_sign_in.dart';
import '../../data/models/user.dart';

class GoogleRepository {
  final GoogleSignInService _googleSignInService;
  final FirestoreService _firestoreService;

  GoogleRepository(this._googleSignInService, this._firestoreService);

  Future<UserModel?> signInWithGoogle() async {
    final user = await _googleSignInService.signInWithGoogle();

    if (user != null) {
      String phone = user.phoneNumber ?? '';
      if (phone.isEmpty) {
        phone = await _promptForPhoneNumber();
      }
      await _firestoreService.saveUserToFirestore(user, phone);

      return UserModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        phoneNumber: phone,
      );
    }

    return null;
  }

  Future<String> _promptForPhoneNumber() async {
    return 'missing phone number';
  }
}

final userRepositoryProvider = Provider<GoogleRepository>((ref) {
  final googleSignInService = GoogleSignInService();
  final firestoreService = FirestoreService();
  return GoogleRepository (googleSignInService, firestoreService);
});
