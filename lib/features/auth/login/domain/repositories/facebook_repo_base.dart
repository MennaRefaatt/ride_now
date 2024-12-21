import '../../data/models/user.dart';

abstract class FacebookRepositoryBase {
  Future<UserModel?> signInWithFacebook();
  Future<void> signOutFacebook();

}