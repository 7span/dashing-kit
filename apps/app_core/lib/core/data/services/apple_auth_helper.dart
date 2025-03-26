import 'dart:async';

import 'package:app_core/modules/auth/model/auth_request_model.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Refer this link for the apple sign in package:
/// https://pub.dev/packages/sign_in_with_apple
class AppleAuthHelper {
  static Future<AuthRequestModel?> signIn(
    BuildContext context, {
    VoidCallback? onSuccess,
    void Function(SignInWithAppleAuthorizationException exception)?
    onError,
  }) async {
    debugPrint('AppleSignIn signIn');
    AuthRequestModel? socialLoginRequest;
    try {
      final user = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      debugPrint('Signin Response : $user');
      const playerId = 'playerId if onesignal is integrated';
      socialLoginRequest = AuthRequestModel(
        name: user.givenName,
        email: user.email,
        provider: 'apple',
        providerId: user.userIdentifier,
        providerToken: user.identityToken,
        oneSignalPlayerId: playerId,
      );
      debugPrint(
        'AppleSignIn request: ${socialLoginRequest.toMap()}',
      );

      if (onSuccess != null) {
        onSuccess();
      }

      return socialLoginRequest;
    } on SignInWithAppleAuthorizationException catch (error) {
      debugPrint('AppleSignIn error: ${error.code}');
      if (onError != null) {
        onError(error);
      }
    }
    return socialLoginRequest;
  }
}
