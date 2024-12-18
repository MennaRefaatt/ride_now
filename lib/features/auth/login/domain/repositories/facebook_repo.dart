import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_sources/firestore_service/firestore_service.dart';
import '../../data/data_sources/facebook_sign_in/facebook_sign_in.dart';
import '../../data/models/user.dart';

class FacebookRepository {
  final FacebookSignInService _facebookSignInService;
  final FirestoreService _firestoreService;

  FacebookRepository(this._facebookSignInService, this._firestoreService);

  Future<UserModel?> signInWithFacebook() async {
    final user = await _facebookSignInService.signInWithFacebook();

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

final facebookRepositoryProvider = Provider<FacebookRepository>((ref) {
  final facebookSignInService = FacebookSignInService();
  final firestoreService = FirestoreService();
  return FacebookRepository(facebookSignInService, firestoreService);
});
