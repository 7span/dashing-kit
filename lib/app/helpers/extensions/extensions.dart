import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide State;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' show format;

import 'package:bloc_boilerplate/app/enum.dart';
import 'package:bloc_boilerplate/app/helpers/extensions/extension_utils.dart';
import 'package:bloc_boilerplate/app/helpers/injection.dart';
import 'package:bloc_boilerplate/core/data/services/auth.service.dart';
import 'package:bloc_boilerplate/core/data/services/network_helper.service.dart';

extension BuildContextX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  bool get isDarkMode => MediaQuery.platformBrightnessOf(this) == Brightness.dark;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;
}

extension DateTimeX on DateTime {
  String defaultFormat() => DateFormat('MMM dd, yyyy').format(this);

  String get ago => format(
        DateTime.now().toUtc().subtract(DateTime.now().toUtc().difference(this)),
      );
}

extension StatusCodeX on StatusCode {
  bool get isSuccess => value == 200 || value == 201 || value == 204;
}

extension IntX on int {
  StatusCode get statusCode => StatusCode.values.firstWhere(
        (StatusCode element) => element.value == this,
        orElse: () => StatusCode.http000,
      );
}

extension GetUserDataExtension on BuildContext {
  String get username => getIt<IAuthService>().getUserData().fold<String>(
        () => '',
        (model) => model[0].name,
      );
}

extension GetUsernameExtension on NavigationResolver {
  bool get isLoggedIn => getIt<IAuthService>().getUserData().fold<bool>(
        () => false,
        (model) => true,
      );
}

extension AddEventSafe<Event, State> on Bloc<Event, State> {
  /// This extension lets you add event only if there's a network connection. It's useful when you're
  /// implementing caching functionality using [HydratedBloc]
  Future<void> safeAdd(Event event) async {
    const networkInfo = NetWorkInfo();
    final connectivityStatus = await networkInfo.isConnected;
    if (connectivityStatus == ConnectionStatus.online) {
      add(event);
    }
  }
}

extension DurationDoubleExtension on double {
  ///Usage
  ///```dart
  ///2.milliseconds
  ///```
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  ///Usage
  ///```dart
  ///2.ms
  ///```
  Duration get ms => milliseconds;

  ///Usage
  ///```dart
  ///2.seconds
  ///```
  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  ///Usage
  ///```dart
  ///2.minutes
  ///```
  Duration get minutes => Duration(seconds: (this * Duration.secondsPerMinute).round());

  ///Usage
  ///```dart
  ///2.hours
  ///```
  Duration get hours => Duration(minutes: (this * Duration.minutesPerHour).round());

  ///Usage
  ///```dart
  ///2.days
  ///```
  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());
}

extension DurationIntegerExtension on int {
  Duration get seconds => Duration(seconds: this);

  Duration get days => Duration(days: this);

  Duration get hours => Duration(hours: this);

  Duration get minutes => Duration(minutes: this);

  Duration get milliseconds => Duration(milliseconds: this);

  Duration get microseconds => Duration(microseconds: this);

  Duration get ms => milliseconds;
}

extension AppStringUtils on String {
  /// Discover if the String is a URL file
  bool get isURL => ExtensionUtils.isURL(this);

  /// capitalize the String
  String get capitalize => ExtensionUtils.capitalize(this);

  /// Capitalize the first letter of the String
  String get capitalizeFirst => ExtensionUtils.capitalizeFirst(this);

  /// remove all whitespace from the String
  String get removeAllWhitespace => ExtensionUtils.removeAllWhitespace(this);

  /// converter the String
  String? get camelCase => ExtensionUtils.camelCase(this);

  /// Discover if the String is a valid URL
  String? get paramCase => ExtensionUtils.paramCase(this);
}
