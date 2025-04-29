#!/bin/bash

set -e

# Path to firebase_options.dart
FIREBASE_OPTIONS_PATH="apps/app_core/lib/firebase_options.dart"

# Check if the file exists
if [[ ! -f "$FIREBASE_OPTIONS_PATH" ]]; then
  echo ":x: firebase_options.dart not found at $FIREBASE_OPTIONS_PATH"
  exit 1
fi

# === Config ===
APP_ID=$(awk '
  $0 ~ /static const FirebaseOptions android = FirebaseOptions\(/ { in_android=1 }
  in_android && $0 ~ /appId:/ {
    gsub(/.*appId:[[:space:]]+'\''/, "", $0)
    gsub(/'\''.*,?/, "", $0)
    print $0
    exit
  }
' "$FIREBASE_OPTIONS_PATH")
APK_PATH="./apps/app_core/build/app/outputs/flutter-apk/app-release.apk"

# === Ask for Group Name ===
echo ":group: Enter the Firebase tester group name you want to distribute to:"
read GROUP_NAME

if [[ -z "$GROUP_NAME" ]]; then
  echo ":x: Group name cannot be empty!"
  exit 1
fi

# === Ask for Release Notes ===
echo ":memo: Enter the release notes (press Enter to skip):"
read RELEASE_NOTES

if [[ -z "$RELEASE_NOTES" ]]; then
  RELEASE_NOTES="No release notes provided"
fi

# === Build APK ===
echo ":tools: Building APK..."
melos run build-apk

# === Upload to Firebase App Distribution ===
echo ":rocket: Uploading APK to Firebase App Distribution..."
firebase appdistribution:distribute "$APK_PATH" \
  --app "$APP_ID" \
  --groups "$GROUP_NAME" \
  --release-notes "$RELEASE_NOTES"

# === Done ===
echo ":white_check_mark: Upload complete!"
