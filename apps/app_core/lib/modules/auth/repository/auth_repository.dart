import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import 'package:app_core/core/data/models/user_model.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This repository contains the contract for login and logout function
abstract interface class IAuthRepository {
  TaskEither<Failure, Unit> login(String email, String password);

  Future<bool> logout();

  Future<bool> signInWithGoogle();
}

/// This class contains the implementation for login and logout functions.
// ignore: comment_references
/// This repository connects with [IAuthService] for setting the data of the user
/// that is given by the API Response
class AuthRepository implements IAuthRepository {
  const AuthRepository();

  static final firebaseAuthInstance = FirebaseAuth.instance;

  @override
  TaskEither<Failure, Unit> login(
    String email,
    String password,
  ) {
    final userModel = UserModel(
      name: 'cavin',
      email: 'demo@gmail.com',
      id: 1,
      profilePicUrl: 'profilePicUrl',
    );
    return getIt<IHiveService>()
        .setAccessToken('uniquetoken')
        .flatMap((_) => getIt<IHiveService>().setUserData(userModel));
  }

  @override
  Future<bool> logout() async {
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      await firebaseAuthInstance.signOut();
      //clear auth tokens from the local storage
      await getIt<IHiveService>().clearData().run();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await firebaseAuthInstance.signInWithCredential(credential);
      if (googleUser != null) {
        final userEmail = googleUser.email;
        final userName = googleUser.displayName;
        final userUid = firebaseAuthInstance.currentUser?.uid;
        if (userUid != null) {
          final userModel = UserModel(
            name: userName ?? 'Unknown',
            email: userEmail,
            id: 1,
            profilePicUrl: 'profilePicUrl',
          );
          await getIt<IHiveService>().setAccessToken(userUid).run();
          await getIt<IHiveService>().setUserData(userModel).run();
        }
      } else {
        return false;
      }
      return true;
    } catch (error) {
      return false;
    }
  }
}
