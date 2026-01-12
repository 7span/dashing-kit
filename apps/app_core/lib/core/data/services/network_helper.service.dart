import 'dart:async';

import 'package:app_core/app/enum.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

/// This class is used for checking the status of internet connectivity
class NetWorkInfoService {
  NetWorkInfoService._internal();
  static final instance = NetWorkInfoService._internal();
  late final StreamSubscription<DataConnectionStatus> listener;
  void init() {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          connectionStatus = ConnectionStatus.online;
        case DataConnectionStatus.disconnected:
          connectionStatus = ConnectionStatus.offline;
      }
    });
  }

  Future<void> dispose() async {
    await listener.cancel();
  }

  ConnectionStatus connectionStatus = ConnectionStatus.online;

  ConnectionStatus get isConnected => connectionStatus == ConnectionStatus.online
      ? ConnectionStatus.online
      : ConnectionStatus.offline;
}
