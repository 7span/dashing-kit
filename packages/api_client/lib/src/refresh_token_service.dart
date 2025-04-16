import 'package:api_client/src/refresh_token_response_model.dart';
import 'package:fpdart/fpdart.dart';

import '../api_client.dart';
import 'hive.api.service.dart';

class RefreshTokenService {
  final RestApiClient client;

  RefreshTokenService(this.client);

  late UserTokenSaveService userTokenSaveService;

  TaskEither<Failure, RefreshTokenDTO> _callRefreshTokenApi({
    required String refreshToken,
    required String refreshTokenEndpoint,
  }) {
    return client
        .request(
          path: refreshTokenEndpoint,
          requestType: RequestType.post,
          body: {'token': refreshToken},
        )
        .chainEither(RepositoryUtils.checkStatusCode)
        .chainEither(
          (r) => RepositoryUtils.mapToModel(
            () => RefreshTokenDTO.fromMap(
              r.data as Map<String, dynamic>,
            ),
          ),
        );
  }

  TaskEither<Failure, String> _storeRefreshedTokens(
    String token,
    String refreshToken,
  ) {
    return userTokenSaveService
        .setAccessToken(token)
        .flatMap(
          (_) => userTokenSaveService.setRefreshToken(refreshToken),
        )
        .map((f) => token);
  }

  TaskEither<Failure, String> fetchRefreshToken(
    String refreshTokenEndpoint,
  ) {
    return HiveApiService.instance
        .getRefreshToken()
        .map(
          (refreshToken) => _callRefreshTokenApi(
            refreshToken: refreshToken,
            refreshTokenEndpoint: refreshTokenEndpoint,
          ),
        )
        .getOrElse(
          () => throw Exception('Failed to get refresh token'),
        )
        .flatMap(
          (r) => _storeRefreshedTokens(
            r.data!.token!,
            r.data!.refreshToken!,
          ),
        );
  }
}
