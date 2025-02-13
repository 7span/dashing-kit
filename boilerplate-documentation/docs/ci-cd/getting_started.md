---

sidebar_position: 2
description: Set up a CI/CD pipeline for your Flutter app.

---

# Getting Started 🎯

In this section will guide you through setting up a CI/CD pipeline for your Flutter app, from prerequisites to the first automated build.

## **Prerequisites**

Before setting up CI/CD, ensure you have:

- A Flutter project with a **Git** repository (GitHub, GitLab, Bitbucket, etc.).
- A **CI/CD service** (GitHub Actions, GitLab CI/CD, Bitrise, Codemagic, etc.).
- Accounts for **Google Play Console** (Android) and **App Store Connect** (iOS) if deploying to production.
- API keys, signing certificates, and Firebase/App Store credentials for authentication.

## **Setting Up a CI/CD Tool**

Choose a CI/CD provider based on your needs:

| CI/CD Tool | Best For | Free Plan Available? |
| --- | --- | --- |
| GitHub Actions | GitHub-hosted repos, easy setup | ✅ |
| GitLab CI/CD | GitLab repositories | ✅ |
| Bitrise | No-code CI/CD for mobile apps | ✅ |
| Codemagic | Flutter-first CI/CD | ✅ |

## **Basic CI/CD Pipeline Overview**

A typical CI/CD pipeline for Flutter includes:

1. **Code Checkout** → Pulls the latest changes from the repository.
2. **Environment Setup** → Installs Flutter, dependencies, and required tools.
3. **Static Analysis & Testing** → Runs `flutter analyze` and `flutter test`.
4. **Build Generation** → Creates APK, AAB, or IPA files for deployment.
5. **Code Signing** → Signs apps for release (required for iOS and Android Play Store).
6. **Deployment** → Publishes the app to Firebase App Distribution, Play Store, or TestFlight.

## **Access and Authentication**

Once you have installed the application, you can access it by following these steps:

1. Launch the application from your start menu (Windows) or Applications folder (macOS).
2. The application will open in your default web browser.
3. You will be prompted to log in or create a new account.

---

That concludes the **Getting Started** section. As you progress through this documentation, you'll find more in-depth information on various aspects of CI/CD for Flutter, including pipeline configuration, automated testing, deployment strategies, and troubleshooting common issues.