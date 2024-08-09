import 'package:api_client/api_client.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

final openApiClient = getIt.get<ApiClient>(instanceName: 'open');

final closeApiClient = getIt.get<ApiClient>(instanceName: 'close');
