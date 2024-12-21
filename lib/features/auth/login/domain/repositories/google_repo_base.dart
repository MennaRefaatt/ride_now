import '../../data/models/user.dart';

abstract class GoogleRepositoryBase {
  Future<UserModel?> signInWithGoogle();
  Future<void> signOutGoogle();
}
