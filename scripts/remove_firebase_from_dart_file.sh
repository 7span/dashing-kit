#!/bin/zsh

# Path to the Dart file
DART_FILE="apps/app_core/lib/bootstrap.dart"

# Check if the Dart file exists
if [ ! -f "$DART_FILE" ]; then
  echo "❗ Error: File not found - $DART_FILE"
  exit 1
fi

echo "Removing Firebase references from Dart file..."

# Remove Firebase-related imports
sed -i '' '/import .*firebase_options/d' "$DART_FILE"
sed -i '' '/import .*firebase_core/d' "$DART_FILE"

# Remove Firebase initialization logic
sed -i '' '/\/\/ await Firebase\.initializeApp(options: DefaultFirebaseOptions\.currentPlatform);/d' "$DART_FILE"
sed -i '' '/await Firebase\.initializeApp/,/);/d' "$DART_FILE"

# Clean up potential empty lines left behind
sed -i '' '/^$/d' "$DART_FILE"

echo "✅ Firebase references successfully removed from Dart file!"
