// ignore_for_file: avoid_dynamic_calls


import 'package:hive_ce_flutter/hive_flutter.dart';

part 'subscription_model.g.dart';

class SubscriptionModel {
  SubscriptionModel({this.user});

  SubscriptionModel.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  User? user;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  User({this.subscription});

  User.fromJson(dynamic json) {
    subscription =
        json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null;
  }
  Subscription? subscription;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    return data;
  }
}

class Subscription {
  Subscription({this.plan, this.subscriptionPurchaseToken, this.subscriptionTransactionId});

  Subscription.fromJson(dynamic json) {
    plan = json['plan'] != null ? ActiveSubscriptionPlanEntity.fromJson(json['plan']) : null;
    subscriptionPurchaseToken = json['subscriptionPurchaseToken'];
    subscriptionTransactionId = json['subscriptionTransactionId'];
  }
  ActiveSubscriptionPlanEntity? plan;
  String? subscriptionPurchaseToken;
  String? subscriptionTransactionId;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 5)
class ActiveSubscriptionPlanEntity extends HiveObject {
  ActiveSubscriptionPlanEntity({this.id, this.name, this.isLegacy, this.provider, this.productId});

  ActiveSubscriptionPlanEntity.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    isLegacy = json['isLegacy'];
    provider = json['provider'];
    productId = json['productPaddleId'];
  }

  @HiveField(1)
  int? id;

  @HiveField(2)
  String? name;

  @HiveField(3)
  bool? isLegacy;

  @HiveField(4)
  String? provider;

  @HiveField(5)
  String? productId;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isLegacy'] = isLegacy;
    data['provider'] = provider;
    data['productPaddleId'] = productId;
    return data;
  }
}
