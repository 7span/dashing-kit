#!/bin/zsh

GRADLE_FILE="apps/app_core/android/app/build.gradle.kts"

printf "Do you want to change the App name? (y/n): "
read CHANGE_APP_NAME


if [[ "$CHANGE_APP_NAME" == "y" || "$CHANGE_APP_NAME" == "Y" || "$CHANGE_APP_NAME" == "yes" ]]; then
# Prompt for the app name
printf "Enter the new app name: "
read APP_NAME

# Update the appLabel in productFlavors
sed -i '' "s/manifestPlaceholders\[\"appLabel\"\] = \"Core App\"/manifestPlaceholders\[\"appLabel\"\] = \"$APP_NAME\"/g" $GRADLE_FILE
sed -i '' "s/manifestPlaceholders\[\"appLabel\"\] = \"Core App QA\"/manifestPlaceholders\[\"appLabel\"\] = \"$APP_NAME QA\"/g" $GRADLE_FILE
sed -i '' "s/manifestPlaceholders\[\"appLabel\"\] = \"Core App Staging\"/manifestPlaceholders\[\"appLabel\"\] = \"$APP_NAME Staging\"/g" $GRADLE_FILE

echo "Updated appLabel to $APP_NAME in $GRADLE_FILE"
fi


# Prompt for the package name
printf "Do you want to change the package name? (y/n): "
read CHANGE_PACKAGE

if [[ "$CHANGE_PACKAGE" == "y" || "$CHANGE_PACKAGE" == "Y" || "$CHANGE_PACKAGE" == "yes" ]]; then
  printf "Enter the new package name(com.abc.xyz): "
  read PACKAGE_NAME
  
  # Define the old package name
  OLD_PACKAGE="com.flutter.boilerplate.app"
  
  echo "Changing package name from $OLD_PACKAGE to $PACKAGE_NAME"
  
  cd apps/app_core
  # Find all files containing the old package name and replace it
  dart run change_app_package_name:main $PACKAGE_NAME

  cd ../..
  echo "Updated package name in $FILE"
fi

# Prompt for the app logo
printf "Do you want to change the App Logo? (y/n): "
read CHANGE_APP_LOGO

if [[ "$CHANGE_APP_LOGO" == "y" || "$CHANGE_APP_LOGO" == "Y" || "$CHANGE_APP_LOGO" == "yes" ]]; then
  printf "Make sure that you've entered the correct path to the new app logo in the file: \npackages/app_ui/assets/images/logo.png (The name should be logo.png only)"

  printf "\nIf you've not done that, please do it first and then run this script again."
  printf "Do you want to continue? (y/n): "
  read CONTINUE

  if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" || "$CONTINUE" == "yes" ]]; then
    cd apps/app_core
    dart run flutter_launcher_icons
  else
    echo "Operation cancelled by user"
    exit 0
  fi

fi


# Summary
echo "=============== Summary ==============="
if [[ "$CHANGE_APP_NAME" == "y" || "$CHANGE_APP_NAME" == "Y" ]]; then
echo "App name changed to: $APP_NAME"
fi

if [[ "$CHANGE_PACKAGE" == "y" || "$CHANGE_PACKAGE" == "Y" ]]; then
  echo "Package name changed from $OLD_PACKAGE to $PACKAGE_NAME"
  echo "Since you've changed the package name, you'll need to re-configure your firebase project and update the google-services.json file"

fi

if [[ "$CHANGE_APP_LOGO" == "y" || "$CHANGE_APP_LOGO" == "Y" ]]; then
  echo "App logo has been changed"
fi
echo "======================================"