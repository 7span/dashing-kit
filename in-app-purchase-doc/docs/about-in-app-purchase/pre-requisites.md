---
sidebar_position: 4
---

# What are pre-requisites to implement in-app purchases?

🛠️ Here are some key pre-requisites required before implementing in-app purchases on iOS and Android.

**1. Developer Account & App Setup** 
- iOS: Enroll in the Apple Developer Program & set up App Store Connect. 
- Android: Register for a Google Play Developer Account & enable Google Play Billing.

**2. App Permissions & Store Configuration**
- Enable in-app purchases in the App Store Connect (iOS) & Google Play Console (Android).
- Set up App ID, bundle identifier, and billing permissions in the app's manifest.

**3. SDK & API Requirements**
- iOS: Install StoreKit Framework for purchase handling.
- Android: Integrate Google Play Billing Library for transactions.
- Cross-Platform: Use plugins like Flutter’s in_app_purchase, React Native IAP, or Unity IAP.

**4. In-App Product Setup**
- Define product types (consumables, non-consumables, and subscriptions) in App Store Connect & Google Play Console.
- Configure pricing, localization, and regional availability.

**5. Security & Testing Readiness**
- Enable Sandbox Testing (iOS) & License Testing (Android).
- Implement secure API calls & transaction validation to prevent fraud.
- Ensure compliance with PCI-DSS & local payment security regulations.

**6. (Optional but Recommended) Backend Setup**
- Use App Store Server API (iOS) & Google Play Developer API (Android) for server-side receipt validation.
- Set up subscription management (renewals, cancellations, refunds).

These steps ensure your app is fully prepared to implement in-app purchases. 