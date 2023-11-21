import 'package:fitness_app/app/enum.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

/// This class is used for checking the status of internet connectivity
class NetWorkInfo {
  const NetWorkInfo();
  Future<ConnectionStatus> get isConnected async => await DataConnectionChecker().hasConnection
      ? ConnectionStatus.online
      : ConnectionStatus.offline;
}
