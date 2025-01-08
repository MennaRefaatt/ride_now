import 'package:flutter/cupertino.dart';

import '../../data/models/user.dart';

abstract class FacebookRepositoryBase {
  Future<UserModel?> signInWithFacebook(BuildContext context);
  Future<void> signOutFacebook();

}