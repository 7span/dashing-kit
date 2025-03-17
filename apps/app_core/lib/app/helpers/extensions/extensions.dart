// ignore_for_file: comment_references

import 'package:auto_route/auto_route.dart';
import 'package:app_core/app/enum.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_core/core/data/services/network_helper.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension GetUserDataExtension on BuildContext {
  String get username =>
      getIt<IHiveService>().getUserData().fold<String>((_) => '', (model) => model[0].name);
}

extension GetUsernameExtension on NavigationResolver {
  bool get isLoggedIn =>
      getIt<IHiveService>().getUserData().fold<bool>((_) => false, (model) => model.isNotEmpty);

  bool get isAccessed => getIt<IHiveService>().getAccessToken().isSome();
}

extension AddEventSafe<Event, State> on Bloc<Event, State> {
  /// This extension lets you add event only if there's a network connection. It's useful when you're
  /// implementing caching functionality using [HydratedBloc]
  void safeAdd(Event event) {
    if (NetWorkInfoService.instance.connectionStatus == ConnectionStatus.online) {
      add(event);
    }
  }
}
