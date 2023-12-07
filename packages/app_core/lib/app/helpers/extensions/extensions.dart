import 'package:auto_route/auto_route.dart';
import 'package:app_core/app/enum.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/services/auth.service.dart';
import 'package:app_core/core/data/services/network_helper.service.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

extension GetUserDataExtension on BuildContext {
  String get username => getIt<IAuthService>().getUserData().fold<String>(
        (_) => '',
        (model) => model[0].name,
      );
}

extension GetUsernameExtension on NavigationResolver {
  bool get isLoggedIn => getIt<IAuthService>().getUserData().fold<bool>(
        (_) => false,
        (model) => true,
      );
}

extension StatusCodeX on StatusCode {
  bool get isSuccess => value == 200 || value == 201 || value == 204;
}

extension IntX on int {
  StatusCode get getStatusCodeEnum => StatusCode.values.firstWhere(
        (StatusCode element) => element.value == this,
        orElse: () => StatusCode.http000,
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
