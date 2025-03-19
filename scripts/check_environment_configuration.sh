#!/bin/zsh

# Flutter Version Checker Script
# This script checks if Flutter, Melos, and build_runner are up to date
# without automatically updating Flutter

echo "🔍 Checking Flutter, Melos, and build_runner versions..."
echo "========================================================"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Flutter is installed
if ! command_exists flutter; then
  echo "❌ Flutter is not installed or not in PATH"
  exit 1
fi

# Get current Flutter version
CURRENT_FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
echo "✓ Current Flutter version: $CURRENT_FLUTTER_VERSION"

# Check for latest Flutter version without upgrading
echo "\n📦 Checking for latest Flutter version..."

# Use 'flutter version' to check version status, which is more reliable
flutter version > /tmp/flutter_version_output 2>&1

# Parse the output based on specific messages
if grep -q "Flutter is already at the latest version" /tmp/flutter_version_output; then
  echo "✅ Flutter is up to date (version $CURRENT_FLUTTER_VERSION)"
elif grep -q "A new version of Flutter is available" /tmp/flutter_version_output; then
  # Try to extract the latest version from the message
  LATEST_VERSION=$(grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+" /tmp/flutter_version_output | head -1)
  
  if [ -n "$LATEST_VERSION" ]; then
    echo "⚠️ A newer Flutter version is available: $LATEST_VERSION"
  else
    echo "⚠️ A newer Flutter version is available"
  fi
  echo "   Current version: $CURRENT_FLUTTER_VERSION"
  echo "   Run 'flutter upgrade' to update Flutter"
else
  # If neither message is found, assume Flutter is up to date
  echo "✅ Flutter appears to be up to date (version $CURRENT_FLUTTER_VERSION)"
fi

# Clean up temp file
rm -f /tmp/flutter_version_output

# Check for Melos
echo "\n📦 Checking Melos..."
if command_exists melos; then
  MELOS_VERSION=$(melos --version 2>/dev/null)
  echo "✓ Melos is installed (version $MELOS_VERSION)"
  
  # Update Melos
  echo "📦 Updating Melos..."
  dart pub global activate melos >/dev/null 2>&1
  NEW_MELOS_VERSION=$(melos --version 2>/dev/null)
  
  if [ "$MELOS_VERSION" = "$NEW_MELOS_VERSION" ]; then
    echo "✅ Melos is already on the latest version ($MELOS_VERSION)"
  else
    echo "⚠️ Melos was updated from $MELOS_VERSION to $NEW_MELOS_VERSION"
  fi
else
  echo "❌ Melos is not installed. Installing..."
  dart pub global activate melos >/dev/null 2>&1
  
  if command_exists melos; then
    NEW_MELOS_VERSION=$(melos --version 2>/dev/null)
    echo "✅ Melos was installed successfully (version $NEW_MELOS_VERSION)"
  else
    echo "❌ Failed to install Melos. Please install manually with 'dart pub global activate melos'"
  fi
fi

# Check for build_runner
echo "\n📦 Checking build_runner..."
BUILD_RUNNER_VERSION=$(dart pub global list | grep build_runner 2>/dev/null)

if [ -n "$BUILD_RUNNER_VERSION" ]; then
  echo "✓ build_runner is installed ($BUILD_RUNNER_VERSION)"
  
  # Update build_runner
  echo "📦 Updating build_runner..."
  dart pub global activate build_runner >/dev/null 2>&1
  NEW_BUILD_RUNNER_VERSION=$(dart pub global list | grep build_runner 2>/dev/null)
  
  if [ "$BUILD_RUNNER_VERSION" = "$NEW_BUILD_RUNNER_VERSION" ]; then
    echo "✅ build_runner is already on the latest version"
  else
    echo "⚠️ build_runner was updated to latest version"
  fi
else
  echo "❌ build_runner is not installed. Installing..."
  dart pub global activate build_runner >/dev/null 2>&1
  
  if [ -n "$(dart pub global list | grep build_runner 2>/dev/null)" ]; then
    echo "✅ build_runner was installed successfully"
  else
    echo "❌ Failed to install build_runner. Please install manually with 'dart pub global activate build_runner'"
  fi
fi

echo "\n========================================================"
echo "✨ All checks completed!\n"

# Print system info
echo "System Information:"
echo "- Flutter: $CURRENT_FLUTTER_VERSION"
DART_VERSION=$(dart --version 2>&1 | awk '{print $4}')
echo "- Dart: $DART_VERSION"
echo "- Platform: $(uname -s) $(uname -m)"
echo "- Path: $(which flutter)"
echo "\nRun this script again anytime to check for updates."