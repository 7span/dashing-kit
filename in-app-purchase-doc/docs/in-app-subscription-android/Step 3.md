---
sidebar_position: 3
---

## Base plans and offers

:::info Base plan
- A base plan specifies a unique set of attributes for a given billing period and renewal type.
- You can specify whether a subscription renews automatically (auto-renewing) or is non-renewing (prepaid plan).
- A Subscriptions can contain one or more base plans.
:::

- To add base plans and offers you can simply go from **Add a base plan** showing in starting where how many steps you completed is showing, or scroll down to **Base plans an offers** section and tap **Add base plan**.

![add_subscription](/img/add-subscription/add_subscription_8.png)

- Add Base plan ID and select any Base plan Type from Auto-renewing, Prepaid or Installments.

![add_subscription](/img/add-subscription/add_subscription_9.png)

---
- Here is the difference between all these three.

### 1) Auto-renewing

:::info Auto renewing subscription
- Via auto-renewing users can make recurring payments. 
- The plan automatically renews unless canceled by the user.
- Subscriptions can be canceled by the user, by the developer, or by Google Play's billing system.
:::

- Add values for **Billing period, Grace period, Account hold period, Customer base plan & offer changes** and **Resubscribe**.
- To know about these parameters visit official documentation by Google Play console [here](https://support.google.com/googleplay/android-developer/answer/12154973#base_plan_attributes).

:::note grace period account hold period
- A grace period is the time granted to a user when a renewal payment is declined. 
- The **recommended** grace period is of **3 days** to prevent misuse of the subscription.
- Also Google Play sends notifications to users during a grace period.
:::

:::note account hold period
- The account hold period is the time after the grace period when the user loses access to the subscription, and if payment is not made, the subscription expires.
- The **recommended** account holding period is of **15 days**.
- The difference between **grace period** and **account hold period** is that during account hold, you should block the access to your premium content. During grace period, you can allow the user to view it.
:::

![add_subscription](/img/add-subscription/add_subscription_10.png)
![add_subscription](/img/add-subscription/add_subscription_11.png)

### 2) Prepaid

:::info Prepaid subscription
- Via prepaid subscription, users pay in advance. 
- They will need to make a new payment to extend their plan.
- Users can make these purchases either through your app or through the Google Play Store's subscriptions center.
:::

- Define values for **Duration** and **Allow extension**.

![add_subscription](/img/add-subscription/add_subscription_12.png)

### 3) Installments

:::info Installments subscription
- For installments users commit to a fixed number of monthly payments.
- Prices are set for the monthly payment amount. 
- This option is only available in some select countries and regions..
:::

- Define values for **Commitment period ,Renewal type, Grace period, Account hold period, Customer base plan & offer changes** and **Resubscribe**.

![add_subscription](/img/add-subscription/add_subscription_13.png)
![add_subscription](/img/add-subscription/add_subscription_14.png)

:::note Note
- At this time, developers can only offer this base plan type to users in the following countries: Brazil, France, Italy, and Spain.
:::

---

- Tags can be used to determine which offer to show when the user is eligible for more than one.
- You can add up to 20 tags and also users cannot see tags.

![add_subscription](/img/add-subscription/add_subscription_15.png)

- Now you are good to go for adding most important thing, price :) 
- You can set different pricing for different countries like shown below.

![add_subscription](/img/add-subscription/add_subscription_16.png)

- To assign same price to each country select **Set prices** and select checkbox country/regions.
- Like wise you can select group of countries to set prices.
- Tap on **Set price** button on right bottom to set price and save.

![add_subscription](/img/add-subscription/add_subscription_17.png)
![add_subscription](/img/add-subscription/add_subscription_18.png)

- Save the pricing and voila subscription is created.
- You can activate subscription right away.

![add_subscription](/img/add-subscription/add_subscription_19.png)

- This is how subscription section will looks like.

![add_subscription](/img/add-subscription/add_subscription_20.png)
