---

sidebar_position: 3
description: Learn how to set up CI/CD for Flutter using GitHub Actions for Android builds.

---

# CI/CD for Flutter Using GitHub Actions - Android

This guide will walk you through setting up **GitHub Actions** for a Flutter project, from initializing a CI/CD pipeline to securely managing secrets for builds and deployments.

## **1. Prerequisites**

Before setting up GitHub Actions for CI/CD in Flutter, ensure you have:

- A Flutter project in a **GitHub repository**.
- GitHub Actions enabled (enabled by default for public repositories).
- Required authentication details (e.g., **keystore**, **API keys**, **Firebase credentials**).

## **2. Setting Up GitHub Actions in a Flutter Project**

GitHub Actions uses **workflow YAML files** stored in `.github/workflows/`.

### **2.1. Creating a Workflow File**

1. In your Flutter project's root directory, create a `.github/workflows` folder.
2. Inside the folder, create a **CI/CD workflow file**:

```
mkdir -p .github/workflows
touch .github/workflows/flutter-ci.yml
```

1. Open `flutter-ci.yml` and define a basic workflow:

```yaml
name: Flutter Build Apk

on:
  push:
    branches:
      - main
      - development

jobs:
  build--eventmania-sales-apk:
    name: Flutter Build APK
    runs-on: macos-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'
      - run: java --version

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          flutter-version: 3.27.3
          cache: true
          cache-key: "eventmania-sales-sdk-key"
          cache-path: "${{ runner.tool_cache }}/flutter/:channel:-:version:-:arch:"
          pub-cache-key: "eventmania-sales-pub-cache-key"
          pub-cache-path: "${{ runner.tool_cache }}/flutter/:channel:-:version:-:arch:"
      - run: flutter --version

      # Create .env.dev file
      - name: Create .env.dev file
        run: |
          cat <<EOT >> .env.dev
          ENV=Development
          BASE_API_URL=${{ secrets.BASE_API_URL_DEV }}
          ONE_SIGNAL_ID=${{ secrets.ONE_SIGNAL_ID }}
          SEATS_IO_KEY=${{ secrets.SEATS_IO_KEY }}
          EOT

      # Create .env.prod file
      - name: Create .env.prod file
        run: |
          cat <<EOT >> .env.prod
          ENV=Production
          BASE_API_URL=${{ secrets.BASE_API_URL_PROD }}
          ONE_SIGNAL_ID=${{ secrets.ONE_SIGNAL_ID }}
          SEATS_IO_KEY=${{ secrets.SEATS_IO_KEY }}
          EOT

      #5 Setup Keystore
      - name: Decode Keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks

      - name: Create key.properties
        run: |
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=keystore.jks" >> android/key.properties

      # Create/modify local.properties
      - name: Create local.properties for Dev
        run: |
          echo "flutter.sdk=/path/to/flutter" >> android/local.properties
          echo "flutter.versionCode=1" >> android/local.properties
          echo "flutter.versionName=1.0" >> android/local.properties

      # Install melos
      - name: Install melos
        run: dart pub global activate melos

      # Setup melos to resolve dependencies
      - name: Setup melos
        run: melos bs

      # Generate routes and environment variables
      - name: Generate routes and environment variables
        run: melos run build-runner

      # Generate localization keys
      - name: Run Localisation Key Generation
        run: melos run locale-gen

      # Generate assets
      - name: Run Asset generation
        run: melos run asset-gen

      # Build Android aab for prod flavor
      - name: Build Android aab For Production
        run: melos run build-aab-prod

      # Build Android apk for prod flavor
      #- name: Build Android apk For Dev
      #  run: melos run build-apk-dev

      # Upload the built APK artifact
      - name: Upload the build Artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-release
          path: build/app/outputs/bundle/release/app-release.aab

```

This workflow:

✅ Runs on code pushes and pull requests to the `main` &  `development` branch.

✅ Checks out the repository.

✅ Installs Flutter.

✅ Creates .env(s).

✅ Setups key.properties & creates local.properties

✅ Melos run configurations and code generations.

✅ Builds a **release APK**.

✅ Uploads the APK as an artifact for download.

## **3. Managing Secrets in GitHub Actions**

For secure access to **signing keys, API tokens, and Firebase credentials**, store them as **GitHub Secrets**.

### **3.1. Adding Secrets to GitHub**

1. Go to your GitHub repository.
2. Navigate to **Settings → Secrets and variables → Actions → New repository secret**.
3. Add secrets one by one (e.g., `BASE_API_URL_DEV`, `KEY_ALIAS`,etc.).
4. Formate your keystore.jks to BASE_64 and add to github secrets. ([Online Tool](https://base64.guru/converter/encode/file))

### **Example Secrets to Add**

| Secret Name | Purpose |
| --- | --- |
| `KEYSTORE_BASE64` | Base64-encoded Keystore file for signing Android builds |
| `KEYSTORE_PASSWORD` | Password for the keystore |
| `KEY_ALIAS` | Key alias for signing |
| `KEY_PASSWORD` | Password for the key alias |
| `BASE_API_URL_PROD` | Base Api URL of apis |
| `ONE_SIGNAL_ID` | One signal ID |

## **4. Running and Monitoring the Workflow**

1. Push changes to the **main** branch or create a **pull request**.
2. Navigate to **GitHub → Actions**.
3. Click on the running workflow to monitor logs.
4. Download artifacts (APK/IPA) after a successful build.

## **5. Summary**

✅ **Configured GitHub Actions** for Flutter CI/CD.

✅ **Secured sensitive credentials** using GitHub Secrets.

✅ **Automated app builds** for Android.

---

IIn this section, you have set up a robust **CI/CD pipeline** for your Flutter project using **GitHub Actions**, secured sensitive credentials with **GitHub Secrets**, automated app builds 🚀