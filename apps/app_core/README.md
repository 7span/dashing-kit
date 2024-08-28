### Flavours set-up (Android)

Add flavours in build.gradle as

```
 flavorDimensions "flavors"
    productFlavors {
        dev {
            dimension "flavors"
            versionNameSuffix "Dev"
        }
        prod {
            dimension "flavors"
        }
    }
```

Create folder as "dev" and "prod" inside ```android/src/dev``` put  ```google-services.json```
inside that folder as ```android/src/dev/google-services.json```

### Flavours set-up (iOS)

- Create folder as "dev" and "prod" inside ```ios/config/dev``` and ```ios/config/prod```
  put  ```GoogleService-Info.plist```
  inside that folder as ```ios/config/dev/GoogleService-Info.plist```
  and ```ios/config/prod/GoogleService-Info.plist```
- Add one run script in build phases

```

# Get a reference to the destination location for the GoogleService-Info.plist
# This is the default location where Firebase init code expects to find GoogleServices-Info.plist file.
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
# We have named our Build Configurations as Debug-dev, Debug-prod etc.
# Here, dev and prod are the scheme names. This kind of naming is required by Flutter for flavors to work.
# We are using the $CONFIGURATION variable available in the XCode build environment to get the build configuration.
if [ "${CONFIGURATION}" == "Debug-prod" ] || [ "${CONFIGURATION}" == "Release-prod" ] || [ "${CONFIGURATION}" == "Profile-prod" ] || [ "${CONFIGURATION}" == "Release" ]; then
cp "${PROJECT_DIR}/config/prod/GoogleService-Info.plist" "${PLIST_DESTINATION}/GoogleService-Info.plist"
echo "Production plist copied"
elif [ "${CONFIGURATION}" == "Debug-dev" ] || [ "${CONFIGURATION}" == "Release-dev" ] || [ "${CONFIGURATION}" == "Profile-dev" ] || [ "${CONFIGURATION}" == "Debug" ]; then
cp "${PROJECT_DIR}/config/dev/GoogleService-Info.plist" "${PLIST_DESTINATION}/GoogleService-Info.plist"
echo "Development plist copied"
fi


```

- For more info
  refer [this](https://kmtsandeepanie.medium.com/set-up-multiple-firebase-environments-in-flutter-9f88bc284454)
  link

- To run in specific env we have set up the flavours
- flutter run --flavor dev -t lib/main_development.dart

- To build APK specific env
- flutter build apk --release --flavor dev -t lib/main_development.dart
