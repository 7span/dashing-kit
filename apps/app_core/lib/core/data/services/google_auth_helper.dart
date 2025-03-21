import 'package:app_core/modules/auth/model/auth_request_model.dart';
import 'package:app_translations/app_translations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Refer this link for the google sign in package:
/// https://pub.dev/packages/google_sign_in
class GoogleAuthHelper {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static Future<UserCredential?> signIn(
    BuildContext context, {
    VoidCallback? onSuccess,
    void Function(Exception exception)? onError,
  }) async {
    debugPrint('GoogleSignIn signIn');

    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        if (context.mounted) {
          final exception = Exception(context.t.operation_cancelled);
          if (onError != null) {
            onError(exception);
          }
          return null;
        }
      }

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (onSuccess != null) {
        onSuccess();
      }

      return userCredential;
    } catch (error) {
      debugPrint('GoogleSignIn error: $error');
      if (context.mounted && onError != null) {
        onError(
          error is Exception ? error : Exception(error.toString()),
        );
      }
    }
    return null;
  }

  static Future<void> signOut() async {
    debugPrint('GoogleSignIn signOut');
    await _googleSignIn.signOut();
  }

  static GoogleSignInAccount? getCurrentUser() {
    debugPrint('GoogleSignIn getCurrentUser');
    return _googleSignIn.currentUser;
  }

  static Future<AuthRequestModel?> getUserInfo(
    BuildContext context,
  ) async {
    debugPrint('GoogleSignIn getUserInfo');

    AuthRequestModel? requestModel;
    final user = _googleSignIn.currentUser;

    if (user != null) {
      final token = await user.authentication.then(
        (auth) => auth.accessToken,
      );
      debugPrint('Token: $token');
      const playerId = 'playerId if onesignal is integrated';
      requestModel = AuthRequestModel(
        name: user.displayName,
        email: user.email,
        provider: 'google',
        providerId: user.id,
        providerToken: token,
        oneSignalPlayerId: playerId,
      );
    }

    return requestModel;
  }
}
