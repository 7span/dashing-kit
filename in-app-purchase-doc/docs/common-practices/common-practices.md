---
sidebar_position: 1
---

# Common practices for In-App Purchase flow.

![Common practice - 1](/img/about-in-app-purchase/funny.png)

### Naming conventions for productID and SubscriptionID

- A product identifier is a string used to uniquely identify every product you wish to sell from your application. 
It is a string identifier that can only contain alphanumeric (A-Z, a-z, 0-9), underscore (_), and period (.) characters. You can use any sequence of these characters for your identifier.
- However, it is recommended that you use the reverse domain name style for example, **com.companyname.application.productid** when creating your identifier.

:::warning Note That...

- Product identifiers are not related to your App ID or Bundle ID. They may look like Bundle IDs, but they are not equivalent to them. Hence, you should not use your App ID or Bundle ID in lieu of your product identifiers in your code.

:::

