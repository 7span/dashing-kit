import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserSubscription extends Equatable {
  UserSubscription({
    this.oldSubscriptionId,
    this.subscriptionTransactionId,
    this.subscriptionPurchaseToken,
  });
  String? oldSubscriptionId;
  String? subscriptionTransactionId;
  String? subscriptionPurchaseToken;

  @override
  List<Object?> get props => [
        oldSubscriptionId,
        subscriptionTransactionId,
        subscriptionPurchaseToken,
      ];
}
