#!/bin/zsh

# Display current working directory for debugging
echo "Current working directory:"
pwd


# Change to the project root if not already there
if [ ! -d "apps/app_core/android" ]; then
  cd "$(dirname "$0")/../../.." || exit
fi

cd apps/app_core/ || exit
# Paths to relevant files
SETTINGS_GRADLE="android/settings.gradle.kts"
BUILD_GRADLE_PROJECT="android/build.gradle.kts"
BUILD_GRADLE_APP="android/app/build.gradle.kts"
DART_FILE="lib/bootstrap.dart"

# Function to safely run sed only if the file exists
safe_sed() {
  if [ -f "$1" ]; then
    sed -i '' "$2" "$1"
  else
    echo "❗ Error: File not found - $1"
  fi
}

# Function to check if a file exists and print an error if it doesn't
check_file_exists() {
  if [ ! -f "$1" ]; then
    echo "❗ Error: File not found - $1"
  fi
}

echo "Removing Firebase references..."

# Check if files exist before attempting to modify them
check_file_exists "$SETTINGS_GRADLE"
check_file_exists "$BUILD_GRADLE_PROJECT"
check_file_exists "$BUILD_GRADLE_APP"

# Remove Firebase references from Gradle files
safe_sed "$SETTINGS_GRADLE" '/id("com.google.gms.google-services")/d'
safe_sed "$BUILD_GRADLE_APP" '/id("com.google.gms.google-services")/d'
safe_sed "$BUILD_GRADLE_APP" '/implementation("com.google.firebase/d'
safe_sed "$BUILD_GRADLE_APP" '/platform("com.google.firebase:firebase-bom:/d'
safe_sed "$BUILD_GRADLE_PROJECT" '/com.google.gms.google-services/d'

# Clean up potential empty lines
echo "Cleaning up empty lines..."
safe_sed "$SETTINGS_GRADLE" '/^$/d'
safe_sed "$BUILD_GRADLE_PROJECT" '/^$/d'
safe_sed "$BUILD_GRADLE_APP" '/^$/d'

echo "Removing Firebase references from Dart file..."

# Remove Firebase references from Dart file
sh scripts/remove_firebase_from_dart_file.sh