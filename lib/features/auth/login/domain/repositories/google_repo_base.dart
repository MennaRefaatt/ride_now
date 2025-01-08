import 'package:flutter/cupertino.dart';

import '../../data/models/user.dart';

abstract class GoogleRepositoryBase {
  Future<UserModel?> signInWithGoogle(BuildContext context);
  Future<void> signOutGoogle();
}
