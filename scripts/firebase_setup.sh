# !/bin/bash

flavor=$1

# Navigate to the app_core directory
cd apps/app_core || exit 1

# Define the path to the build.gradle.kts file
BUILD_GRADLE_KTS_PATH="android/app/build.gradle.kts"

# Check if the build.gradle.kts file exists
if [[ ! -f "$BUILD_GRADLE_KTS_PATH" ]]; then
    echo "❌ build.gradle.kts not found at $BUILD_GRADLE_KTS_PATH"
    exit 1
fi

# Extract the applicationId from build.gradle.kts using awk
application_id=$(awk -F '=' '/applicationId/ {gsub(/[ "]/, "", $2); print $2}' "$BUILD_GRADLE_KTS_PATH" | head -n 1)

# Check if the applicationId was successfully extracted
if [[ -z "$application_id" ]]; then
    echo "❌ Failed to extract applicationId from build.gradle.kts"
    exit 1
fi

# Check if flutterfire_cli is activated
if ! flutterfire --version &> /dev/null; then
    echo "❌ flutterfire_cli is not activated. Activating it now..."
    dart pub global activate flutterfire_cli
    if ! flutterfire --version &> /dev/null; then
        echo "❌ Failed to activate flutterfire_cli. Please check your Dart setup."
        exit 1
    fi
    echo "✅ flutterfire_cli activated successfully."
else
    echo "✅ flutterfire_cli is already activated."
fi

echo "-----------------------------------------------------"

if [[ -z "${flavor}" ]]; then
 
    echo "Configuring Firebase for flavor: production and applicationId: $application_id"

   flutterfire config \
    --out=lib/firebase_options.dart \
    --ios-bundle-id="${application_id}" \
    --ios-out=ios/Runner/GoogleService-Info.plist \
    --android-package-name="${application_id}" \
    --android-out=android/app/google-services.json
    
else
    echo "Configuring Firebase for flavor: $flavor and applicationId: $application_id"

    flutterfire config \
    --out=lib/firebase_options_${flavor}.dart \
    --ios-bundle-id="${application_id}" \
    --ios-out=ios/Runner/GoogleService-Info.plist \
    --android-package-name="${application_id}.${flavor}" \
    --android-out=android/app/google-services.json
fi



cd ../..
echo ""
echo "Firebase ${flavor} application generated successfully!"
echo ""
echo "-----------------------------------------------------"
