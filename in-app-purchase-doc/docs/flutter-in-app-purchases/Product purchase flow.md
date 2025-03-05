---
sidebar_position: 3
---

# Implementation Of Product Purchase Flow

### Initialization 

- Once the application opens **handleSubscription** method is called to initialize the PurchaseDetails stream, along with completing any pending purchases.

```jsx title="splash_screen.dart"
Future<void> handleSubscription() async {
  customInAppPurchase = CustomInAppPurchase();
  customInAppPurchase.init();
  await customInAppPurchase.completePendingPurchases();
  await navigate();
}
```
- Now when user lands to PayWall/Subscription screen we will first fetch all the plans available in Google Play Console with calling **getPlans** method.

```jsx title="subscription_screen.dart"
..getPlans(
      context,
      SubscriptionUtils.subscriptionProductId,
    )
```

- Based on plans fetched, we can show the UI related to card details.
- Now when user buys the consumable products we will call **purchaseCredit** method from **SubscriptionCubit**.
- This calls api to buy consumable products.

```jsx title="subscription_screen.dart"
onTap: () async {
  await context.read<SubscriptionCubit>().purchaseCredit(
        context,
        SubscriptionUtils.subscriptionProductId[0],
      );
},
```

- Implement **BlocListener** to listen to purchase status and show messages accordingly.

```jsx title="subscription_screen.dart"
listener: (context, state) {
  if (state.status == SubscriptionStateStatus.purchaseSuccess) {
    showAppSnackbar(context, 'Purchase Successfully');
    context.read<SubscriptionCubit>().getAndSetActivePlanOfUser();
  }
  flog('status in listen of subscription: ${state.status}');
},
```

:::danger Precaution

Do not forgot to override back gesture to prevent user from closing screen while purchasing is ongoing.

:::

- For example, leveraging **BackButtonListener** from **auto_route** we can showSnackBar to prevent from disposing screen.

```jsx title="subscription_screen.dart"
onBackButtonPressed: () async {
  if (context.read<SubscriptionCubit>().state.status ==
        SubscriptionStateStatus.purchaseLoading) {
    showAppSnackbar(
        context,
        'Please wait until we verify your subscription',
    );
    return true;
  } else {
    return false;
  }
}
```
:::info In-app purchase flow testing

- Create new release of updated apk in internal testing from **Create new release** to test product purchase flow.
- In success case purchased products will be shown at Google Play Store > Payments and subscription > Budget and history.

:::
