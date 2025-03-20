#!/bin/zsh

# Paths to relevant files
SETTINGS_GRADLE="apps/app_core/android/settings.gradle"
BUILD_GRADLE_PROJECT="apps/app_core/android/build.gradle"
BUILD_GRADLE_APP="apps/app_core/android/app/build.gradle"

echo "Removing Firebase references..."

# Remove Firebase plugin from settings.gradle
sed -i '' '/id("com.google.gms.google-services")/d' "$SETTINGS_GRADLE"

# Remove Firebase dependencies and plugins from app/build.gradle
sed -i '' '/id("com.google.gms.google-services")/d' "$BUILD_GRADLE_APP"
sed -i '' '/implementation("com.google.firebase/d' "$BUILD_GRADLE_APP"

# Remove Firebase BOM dependency
sed -i '' '/platform("com.google.firebase:firebase-bom:/d' "$BUILD_GRADLE_APP"

# Remove Firebase references in build.gradle (Project level)
sed -i '' '/com.google.gms.google-services/d' "$BUILD_GRADLE_PROJECT"

# Clean up potential empty lines left behind
echo "Cleaning up empty lines..."
sed -i '' '/^$/d' "$SETTINGS_GRADLE"
sed -i '' '/^$/d' "$BUILD_GRADLE_PROJECT"
sed -i '' '/^$/d' "$BUILD_GRADLE_APP"

echo "Firebase references successfully removed!"


# Path to the Dart file
DART_FILE="apps/app_core/lib/bootstrap.dart"

echo "Removing Firebase references..."

# Remove Firebase-related imports
sed -i '' '/firebase_options/d' "$DART_FILE"
sed -i '' '/firebase_core/d' "$DART_FILE"

# Remove Firebase initialization logic
sed -i '' '/Firebase.initializeApp/d' "$DART_FILE"
sed -i '' '/FirebaseCrashlyticsService.init/d' "$DART_FILE"

# Clean up potential empty lines left behind
echo "Cleaning up empty lines..."
sed -i '' '/^$/d' "$DART_FILE"

echo "Firebase references successfully removed!"
