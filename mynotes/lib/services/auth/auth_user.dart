import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable // will not change after initialization
class AuthUser {
  final bool isEmailVerified;

// required sets field to be assign with naming
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified);
}
