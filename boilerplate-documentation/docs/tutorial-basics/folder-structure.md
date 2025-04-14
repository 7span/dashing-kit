---

sidebar_position: 1
description: What's included in this boilerplate 🌟

---

# Boilerplate Essentials


### What's Included ✨

Out of the box 📦, Boilerplate includes:

- ✅ [Run Configuration](https://developer.android.com/studio/run/rundebugconfig) - Integrated run configurations for **VS-Code** and **Android Studio** so that users can run the app directly without having to configure anything
- ✅ [Environments Configs](https://pub.dev/packages/envied) - Multiple environment support for development, staging, and production
- ✅ [Navigator 2.0](https://pub.dev/packages/auto_route) - Integrated Auto Route for implementing the 
Navigator 2.0 functionality.
- ✅ [BLoC](https://pub.dev/packages/flutter_bloc) - Integrated bloc architecture for scalable, testable code which offers a clear separation between business logic and presentation
- ✅ [Logging](https://pub.dev/packages/logger) - Integrated logger package for extensible logging to capture uncaught Flutter and Dart Exceptions
- ✅ [Authentication](https://pub.dev/packages/hive) - Built-in authentication flow using BLoC and Hive
- ✅ [GitHub Templates](https://github.com/7span/flutter-boilerplate-v2) - Built-in GitHub templates for creating issues and PR's(Pull Request)
- ✅ [Pagination](https://github.com/7span/flutter-boilerplate-v2) - Integrated pagination along with API and repositories
- ✅ [Theme](https://github.com/7span/flutter-boilerplate-v2) - Implemented themes support along with its BLoC that users can use to switch between themes
- ✅ [Extensions](https://github.com/7span/flutter-boilerplate-v2) - Implemented custom utility extension that can boost the workflow of the developer
- ✅ [Localization](https://pub.dev/packages/easy_localization) - Integrated localization support out of the box


<!-- ### File and Folder Structure 📁

Here's the complete folder structure of the boilerplate:

```sh
├── .github
│   ├── pull_request_template.md
│   └── ISSUE_TEMPLATE
│       ├── bug_report.md
│       ├── feature_request.md
│       ├── refactor.md
│       └── documentation.md
├── .idea
│   └── runConfigurations
├── .vscode
│   ├── extensions.json
│   └── launch.json
├── apps
│   └── app_core
        ├── android
        ├── ios
        ├── lib
        │   ├── app
        │   │   ├── config
        │   │   ├── helpers
        │   │   ├── observers
        │   │   ├── routes
        │   │   ├── app.dart
        │   │   └── enum.dart
        │   ├── core
        │   │   ├── data
        │   │   │   ├── model
        │   │   │   │   └── notification_user_model.dart
        │   │   │   ├── repository-utils
        │   │   │   └── service
        │   │   │       ├── firebase_crashlytics_service.dart
        │   │   │       ├── hive.service.dart
        │   │   │       └── network_helper_service.dart
        │   │   ├── domain
        │   │   │   ├── validators
        │   │   │   └── bloc
        │   │   │       └── theme_bloc.dart
        │   │   └── presentation
        │   │       ├── screens
        │   │       │   └── error_screen.dart
        │   │       └── widgets
        │   │           ├── app_snackbar.dart
        │   ├── gen
        │   ├── modules
        │   │   └── splash
        │   │       └── splash_screen.dart
        │   │   ├── auth
        │   │   │   ├── repository
        │   │   │   ├── models
        │   │   │   ├── signin
        │   │   │   │   ├── bloc
        │   │   │   │   │   └── login_bloc.dart
        │   │   │   │   └── screens
        │   │   │   │       └── login_screen.dart
        │   │   │   ├── signup
        │   │   ├── home
        │   │   │   ├── bloc
        │   │   │   │   ├── home_event.bloc.dart
        │   │   │   │   ├── home_state.bloc.dart
        │   │   │   │   └── home.bloc.dart
        │   │   │   │── model
        │   │   │   │   └── post_model.dart
        │   │   │   ├── repository
        │   │   │   │   └── home_repository.dart
        │   │   │   ├── screen
        │   │   │   │   └── home_screen.dart
        │   │   └── profile
        │   │       ├── bloc
        │   │       │   ├── profile_bloc.dart
        │   │       │   ├── profile_state.dart
        │   │       │   └── profile_event.dart
        │   │       │── model
        │   │       ├── repository
        │   │       ├── screen
        │   │       │   └── profile_screen.dart
        │   │       └── bottom_navigation_bar.dart
        │   ├── bootstrap.dart
        │   ├── main_development.dart
        │   ├── main_production.dart
        ├── web
        ├── .gitignore
        ├── analysis_options.yaml
        ├── pubspec.lock
        ├── pubspec.yaml
        └── README.md
``` -->

### Some things to know about the boilerplate 📕

### 1. Spacing 🛰️

In this boilerplate, you won't need to directly use `SizedBox` for spacing, because you'll have better way to do it 😉 In `spacing.dart` file, you will be able to configure the horizontal and vertical spacing parameters. You can use `HSpace` or `VSpace` with their respactive named constructors for adding empty space.

This will ensure that whenever user wants to change the spacing throughout the app, they will be able to do by modifying just this class.


- Thus instead of writing:

```dart
const SizedBox(height: 8)
```

You can write:
```dart
VSpace.xsmall()
```

### 2. Localization 🔠

Localization is configured by default in the boilerplate. So you just need to add the key-value pair of the localization keys inside `app_translations` package.

1. Add a key-value pair like this in the `i18n` folder:

```json
{
    "login": "Login Screen"
}
```

2. After you add the key-value pairs, run the command below to generate the corresponding code:

```bash
melos run locale-gen
```


3. After you run the command, you can use the key in the boilerplate like this:

```dart
Text(context.t.login)
```

You can learn more about the **naming conventions** of the localization keys by this [Blog](https://phrase.com/blog/posts/ruby-lessons-learned-naming-and-managing-rails-i18n-keys/)

### 3. Accessing colors and TextStyles 💈

- If you look at the `extensions.dart` file, you will be able to see extensions related to accessing colors and textstyles. In this boilerplate, we follow material conventions. So to use any color, you can use `context.colorscheme` like this:

```dart
Container(color:context.colorScheme.primary)
```

- Same way, You can use `TextStyles` using `context.textTheme`.

```dart
Text(
    "Dummy Title",
    style: context.textTheme.titleSmall,
  )
```

- If you want to change/add any **Colors** or **TextStyles**, you can configure it from `app_colors.dart` and `app_text_style.dart` respectively.

### 4. Accessing assets 📼

If you're used to add assets in raw string format in Flutter, then this section is for you 😉 We're using [`flutter_gen`](https://pub.dev/packages/flutter_gen) package for utilizing code generation for our assets. So the code that you used to write like this:

```dart
Image.asset("assets/demo.png")
```

will be written like this:

```dart
Assets.images.demo.image()
```

To use assets like the code above, follow the steps:

1. Add the assets in the assets folder 🤷
2. Run the build runner command: `melos run asset-gen`
3. Now you can use assets in the boilerplate like shown above


### 4. Accessing Buttons 🔵

In the boilerplate, There's file named `app_button.dart` that includes all the types and variations of the Buttons that you'll need in the entire App. You can go into that file and configure the buttons as per your App's design. 

Example of using a button:

```dart
AppButton(
    text: context.t.login,
    onPressed:(){},
    isExpanded: true,
    isEnabled: false,
)
```
