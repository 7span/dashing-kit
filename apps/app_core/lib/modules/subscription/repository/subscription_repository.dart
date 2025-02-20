import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/app/helpers/logger_helper.dart';
import 'package:app_core/modules/subscription/model/subscription_model.dart';
import 'package:app_subscription/app_subscription.dart';
import 'package:app_subscription/app_subscription_api.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class SubscriptionRepository {
  SubscriptionRepository();

  late final CustomInAppPurchase _inAppPurchase;

  void init(BuildContext context) {
    _inAppPurchase = getIt<CustomInAppPurchase>();
    _inAppPurchase.init();
  }

  /// This function is used for getting the available plans
  TaskEither<Failure, List<ProductDetails>> getPlans(
    BuildContext context,
    List<String> productsIds,
  ) =>
      TaskEither.tryCatch(
        () => _inAppPurchase.getPlans(productsIds),
        APIFailure.new,
      );

  TaskEither<APIFailure, Unit> buyNonConsumable({
    required ProductDetails productDetails,
    String? oldProductId,
    UserSubscription? userSubscription,
  }) =>
      TaskEither.tryCatch(
        () => _inAppPurchase.buyNonConsumable(
          productDetails,
          oldProductId,
          userSubscription,
          '<packageName>',
        ),
        APIFailure.new,
      ).map((_) => unit);

  TaskEither<APIFailure, Unit> buyConsumable(
    BuildContext context,
    ProductDetails productDetails,
  ) =>
      TaskEither.tryCatch(
        () => _inAppPurchase.buyConsumable(productDetails),
        APIFailure.new,
      ).map((r) => unit);

  TaskEither<Failure, bool> verifyPaymentForIOS({
    required String purchaseToken,
  }) {
    /// implement API call to verify the purchase for IOS.
    return TaskEither.right(false);
  }

  TaskEither<Failure, bool> verifyPaymentForAndroid({
    required String purchaseToken,
    required String productId,
  }) {
    /// implement API call to verify the purchase for Android.
    return TaskEither.right(false);
  }

  TaskEither<Failure, Subscription> getActiveSubscription() {
    /// Set active subscription information in database or Hive accordingly
    return TaskEither.right(Subscription());
  }

  Future<void> dispose(BuildContext context) async {
    flog('dispose of subscription repository');
    await _inAppPurchase.dispose();
  }
}
