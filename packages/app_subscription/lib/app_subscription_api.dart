// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_subscription/user_subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class CustomInAppPurchase {
  /// Init Client Side Setup
  late StreamController<PurchaseDetails> _purchaseStreamController;
  late Stream<PurchaseDetails> _purchaseStream;
  void init() {
    _purchaseStreamController = StreamController<PurchaseDetails>();
    _purchaseStream = _purchaseStreamController.stream;
    listenToPurchaseUpdatedStream();
  }

  Stream<PurchaseDetails> getPurchaseStream() => _purchaseStream;

  /// Init SDK Setup
  late StreamSubscription<List<PurchaseDetails>> _streamSubscription;
  final Stream<List<PurchaseDetails>> _purchaseUpdatedStream =
      InAppPurchase.instance.purchaseStream;

  /// Get plans (Products)
  List<ProductDetails> products = [];

  /// Purchase Details List
  List<PurchaseDetails> purchaseList = [];

  /// Get the list of the plans that we're having
  Future<List<ProductDetails>> getPlans(List<String> productIds) async {
    final response = await InAppPurchase.instance.queryProductDetails(productIds.toSet());
    if (response.error == null) {
      products = response.productDetails;
      for (ProductDetails product in products) {
        debugPrint("Product ID: ${product.id}");
        debugPrint("Product Title: ${product.title}");
        debugPrint("Product price: ${product.price}");
        debugPrint("Product raw price: ${product.rawPrice}");
      }
      return products;
    } else {
      log('get plans error response ${response.error}');
      throw Exception('Error gettting the products');
    }
  }

  /// When the user has subscribed the plan from PlayStore then we have to call the [completePurchase]
  /// method and call the backend API so that they can know that the plan has been purchased from
  /// the PlayStore
  ///
  /// 1. Instantiate the Platform Object of InAppPurchase using [InAppPurchase] class
  /// 2. Query the past purchases of the user
  /// 3. Call the [completePurchase] method to notify the PlayStore
  /// 4. Call the backend API so that backend can know about the purchases
  Future<void> completePendingPurchases() async {
    final addition = Platform.isIOS
        ? InAppPurchase.instance.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>()
        : InAppPurchase.instance.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

    QueryPurchaseDetailsResponse purchases = QueryPurchaseDetailsResponse(pastPurchases: []);
    if (Platform.isAndroid && addition is InAppPurchaseAndroidPlatformAddition) {
      purchases = await addition.queryPastPurchases();
    }
    if (Platform.isIOS && addition is InAppPurchaseStoreKitPlatformAddition) {
      await addition.setDelegate(ExamplePaymentQueueDelegate());
    }
    for (var purchaseDetails in purchases.pastPurchases) {
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  void listenToPurchaseUpdatedStream() {
    debugPrint('listen to purchase stream called');
    _streamSubscription = _purchaseUpdatedStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        log('listening to purchase stream');

        /// Set the purchase list from the stream
        purchaseList = purchaseDetailsList;

        for (var purchaseDetails in purchaseDetailsList) {
          debugPrint('listen to purchase status ${purchaseDetails.status}');
          _purchaseStreamController.sink.add(purchaseDetails);
          // if (purchaseDetails.status == PurchaseStatus.pending) {
          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pending")));
          // } else if (purchaseDetails.status == PurchaseStatus.error) {
          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error")));
          // } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Purchased")));
          // }
        }
      },
    );
  }

  Future<void> buyConsumable(ProductDetails productDetails) async {
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
  }

  Future<void> buyNonConsumable(
    ProductDetails productDetails,
    String? oldProductId,
    UserSubscription? userSubscription,
    String packageName,
  ) async {
    log('buy non consumable');
    log('productDetails.id in app_subscription_api : ${productDetails.id}');
    log('Package name : $packageName');
    PurchaseParam purchaseParam =
        await _getPurchaseParams(productDetails, oldProductId, userSubscription, packageName);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<PurchaseParam> _getPurchaseParams(
    ProductDetails productDetails,
    String? oldSubscriptionId,
    UserSubscription? userSubscription,
    String packageName,
  ) async {
    if (Platform.isAndroid) {
      if (purchaseList.isNotEmpty) {
        if (purchaseList[0].productID.isEmpty) {
          products = [];
          purchaseList.add(
            PurchaseDetails(
              productID: oldSubscriptionId ?? '',
              transactionDate: "",
              verificationData: PurchaseVerificationData(
                localVerificationData: "",
                serverVerificationData: "",
                source: "",
              ),
              status: PurchaseStatus.purchased,
            ),
          );
        }
      }

      purchaseList.map((PurchaseDetails purchase) async {
        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }
      });

      final purchases = Map<String, PurchaseDetails>.fromEntries(
        purchaseList.map(
          (purchase) => MapEntry<String, PurchaseDetails>(
            purchase.productID,
            purchase,
          ),
        ),
      );

      final PurchaseDetails? oldSubscription = (oldSubscriptionId != null &&
              oldSubscriptionId != '0' &&
              oldSubscriptionId.isNotEmpty &&
              productDetails.id != "pro_yearly")
          ? _getOldSubscription(productDetails, purchases)
          : null;
      debugPrint('oldSubscription productID------ ${oldSubscription?.productID}');
      return GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: (oldSubscriptionId != null)
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: GooglePlayPurchaseDetails.fromPurchase(
                    PurchaseWrapper(
                      orderId: userSubscription!.subscriptionTransactionId!,
                      isAcknowledged: true,
                      originalJson: '',
                      purchaseState: PurchaseStateWrapper.purchased,
                      isAutoRenewing: true,
                      purchaseTime: 0,
                      purchaseToken: userSubscription.subscriptionPurchaseToken!,
                      packageName: packageName,
                      signature: '',
                      products: [userSubscription.oldSubscriptionId!],
                    ),
                  ).first,
                  replacementMode: ReplacementMode.withTimeProration,
                )
              : null);
    } else {
      return PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );
    }
  }

  PurchaseDetails? _getOldSubscription(
    ProductDetails? productDetails,
    Map<String, PurchaseDetails>? purchases, [
    String? oldSubscriptionId,
  ]) {
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.

    PurchaseDetails? oldSubscription;
    if (productDetails?.id != oldSubscriptionId && purchases?[oldSubscriptionId] != null) {
      oldSubscription = purchases?[oldSubscriptionId];
    }
    return oldSubscription;
  }

  Future<void> dispose() async {
    log('dispose of subscription API');

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          InAppPurchase.instance.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }

    await _streamSubscription.cancel();
    await _purchaseStreamController.close();
  }
}

class ExamplePaymentQueueDelegate extends SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
