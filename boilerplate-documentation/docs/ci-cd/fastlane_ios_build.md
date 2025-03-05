---

sidebar_position: 4
description: CI/CD using Fastlane for iOS builds.

---

# CI/CD using Fastlane for iOS builds.

## **1. Prerequisites**

Before setting up Fastlane, ensure you have:

- A **macOS machine** with Xcode installed.
- A **Flutter project** set up for iOS (`flutter create .` if missing).
- An **Apple Developer Account** with App Store Connect access.
- A **registered App ID** and **Provisioning Profile** in Apple Developer Portal.
- **CocoaPods installed** (`brew install cocoapods`).
- Latest version of ruby (`brew install ruby`).

---

## **2. Installing Fastlane**

1. Install Fastlane:
    
    ```bash
    brew install fastlane
    ```
    
2. Open the terminal and navigate to your Flutter project’s `ios` directory:
    
    ```bash
    cd ios
    ```
    
3. Initialise Fastlane:
    
    ```bash
    fastlane init
    ```
    
4. When prompted:
    - You will need to choose the type of functionality you want to choose.
        
        ```bash
        1. Automate screenshots
        2. Automate beta distribution to TestFlight
        3. Automate App Store distribution
        4. Manual setup
        ```
        
    - Choose option `Automate beta distribution to TestFlight`.
    - Add Apple Id Username.(Here you can use your `email`) and perform login.
    - Select the development team.
    - Add app identifier if not added on AppStore connect.
    - And Complete the process.
- This step creates these files in Fastlane Directory `Appfile` and `Fastfile`. And in iOS directory creates `Gemfile` and `Gemfile.lock`. Save this files to GitHub project repository.

---

## **3. Creating certificates.**

- Here you will require a new GitHub **private** repository to store the apple id certificates.
- Now execute this command.
    
    ```bash
    fastlane match init
    ```
    
- When prompted:
    - Choose git to store certificates.
    - Add GitHub repository url.
- This step will creates `Matchfile`, `README.md`, `report.xml`.
- Now execute this command.
    
    ```bash
    fastlane match appstore
    ```
    
- Now when this command prompted:
    - Create one match password and save for future.
    
    This will creates a certificate for deployment in AppStore. If it is existed then It will use that.
    

Now you can check all the certificates stored in New GitHub repository.

---

## 4. Match Certificates

To build the app using this we need to match the certificates we stored on another private repository and add it to your build.

- Now we need to add match command to `Fastfile`. Before build command.
    
    ```yaml
     match(app_identifier:"com.example.flutter",type:"appstore")
    ```
    
- Here if upload_to_testflight command fails then change it to pilot() command.
    
    ```yaml
     pilot(api_key_path: "fastlane/store.json", skip_waiting_for_build_processing: true)
    ```
    
    - Here store.json contains. These details are availabe on `AppStore Connect`> `User and Access`> `Integration`> `AppStore Connect Api Keys` > `Teams`.
        
        ```json
        {
            "key_id": "Your_key_id",
            "issuer_id": "issuer_id",
            "key": "-----BEGIN PRIVATE KEY-----{Here enter your key}-----END PRIVATE KEY-----" 
        }
        ```
        
        !<img width="840" alt="Screenshot 2025-02-13 at 3 24 57 PM" src="https://gist.github.com/user-attachments/assets/e8b17283-f7b8-45a2-b626-332f2ca6b06c" />
        

---

## **5. Setting Up GitHub Actions in a Flutter Project**

GitHub Actions uses **workflow YAML files** stored in `.github/workflows/`.

## **5.1. Managing Secrets in GitHub Actions**

For secure access to **signing keys, API tokens, and Firebase credentials**, store them as **GitHub Secrets**.

### **5.1.1 Adding Secrets to GitHub**

1. Go to your GitHub repository.
2. Navigate to **Settings → Secrets and variables → Actions → New repository secret**.
3. Add secrets one by one (e.g., `FASTLANE_PASSWORD`, `MATCH_GIT_BASIC_AUTHORIZATION`,etc.).

### **Example Secrets to Add**

| Secret Name | Purpose |
| --- | --- |
| `FASTLANE_PASSWORD` | Password created while match in fastlane. |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Auth token of the repository containing certificates. |
| `ASC_JSON_KEY` | store.json text if not added to repository. |
| `BASE_API_URL_PROD` | Base Api URL of apis. |
| `ONE_SIGNAL_ID` | One signal ID. |

### **5.2. Creating a Workflow File**

1. In your Flutter project's root directory, create a `.github/workflows` folder.
2. Inside the folder, create a **CI/CD workflow file**:

```
mkdir -p .github/workflows
touch .github/workflows/flutter-build-ios.yml
```

1. Open `flutter-build-ios.yml` and define a basic workflow:

```yaml
name: Flutter Build ipa

on:
  push:
  branches:
    - main
    - development

jobs:
  build--medsurf-ipa:
    name: Flutter Build ipa
    runs-on: macos-latest
    env:
      ASC_JSON_KEY: $${{ secrets.ASC_JSON_KEY }}

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: "temurin"
          java-version: "17"
      - run: java --version

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          flutter-version: 3.24.1
          cache: true

      - run: flutter --version

      - name: Create .env.dev file
        run: |
          cat <<EOT >> packages/abc_core/.env.dev
          ENV=Development
          BASE_API_URL=${{ secrets.BASE_API_URL_DEV }}
          ONE_SIGNAL_APP_ID=${{ secrets.ONE_SIGNAL_APP_ID_DEV }}
          EOT

      - name: Create .env.staging file
        run: |
          cat <<EOT >> packages/abc_core/.env.staging
          ENV=Staging
          BASE_API_URL=${{ secrets.BASE_API_URL_DEV }}
          ONE_SIGNAL_APP_ID=${{ secrets.ONE_SIGNAL_APP_ID_DEV }}
          EOT

      - name: Create .env.prod file
        run: |
          cat <<EOT >> packages/abc_core/.env.prod
          ENV=Production
          BASE_API_URL=${{ secrets.BASE_API_URL_PROD }}
          ONE_SIGNAL_APP_ID=${{ secrets.ONE_SIGNAL_APP_ID_PROD }}
          EOT
          
      - name: Install melos
        run: dart pub global activate melos

      - name: Setup melos
        run: melos bs

      - name: Generate Environments Configurations and Hive Code
        run: melos run build-runner
        
      - name: Run Localisation Key Generation
        run: melos run locale-gen

      - name: Run Asset generation
        run: melos run assets-runner

      - name: check dir
        run: pwd && ls

      - name: Setup fastlane
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: "3.3"
          bundler-cache: true
          working-directory: [APP_IOS_DIRECTORY_PATH]

      - name: Setup AppStore Connect
        run: |
          echo "$ASC_JSON_KEY" >> [store.json Path]

      - name: Instal pods
        run: melos run go-ios-go

      - name: build iOS IPA and send to testflight
        env:
          MATCH_PASSWORD: ${{ secrets.FASTLANE_PASSWORD }}
          MATCH_GIT_BASIC_AUTHORIZATION: ${{ secrets.MATCH_GIT_BASIC_AUTHORIZATION }}
          ASC_JSON_KEY: ${{ secrets.ASC_JSON_KEY }}

        run: cd [iOS Folder Path] && bundle exec fastlane ios beta

      - name: Upload the build Artifact
        uses: actions/upload-artifact@v4
        with:
          name: Runner
          path: apps/medsurf_app/ios/Runner.ipa

```

This workflow:

✅ Runs on code pushes and pull requests to the `main` &  `development` branch.

✅ Checks out the repository.

✅ Installs Flutter.

✅ Creates .env(s).

✅ Setups Fastlane and runs ios beta.

✅ Melos run configurations and code generations.

✅ Builds a **release ipa and shares to TestFlight**.

✅ Uploads the ipa as an artifact for download.

---

For referenced video [Link](https://www.youtube.com/watch?v=CagpigPskeM).