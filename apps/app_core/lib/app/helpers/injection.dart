import 'package:api_client/api_client.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

final RestApiClient userApiClient = getIt.get<RestApiClient>(instanceName: 'user');

final RestApiClient baseApiClient = getIt.get<RestApiClient>(instanceName: 'base');
