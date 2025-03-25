import 'dart:developer';

import 'package:api_client/src/api_enum.dart';
import 'package:api_client/src/api_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graphql/client.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter/services.dart';

/// This class is used for connecting with remote data source using GraphQL
/// as an API Client. This class is responsible for making API requests and
/// sending the response in case of success and error in case of API failure.
final class ApiClient {
  late GraphQLClient graphQLClient;

  final cache = GraphQLCache();

  ///initialize GraphQL for API calling. It is configurable to disable the
  ///cache by providing [isApiCacheEnabled] to false.
  Future<Unit> init({
    required bool isApiCacheEnabled,
    required String baseURL,
  }) async {
    final httpLink = HttpLink(baseURL);
    final AuthLink authLink = AuthLink(getToken: () async => null);
    Link link = authLink.concat(httpLink);

    graphQLClient = GraphQLClient(
      cache: cache,
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
        watchQuery: Policies(fetch: FetchPolicy.noCache),
      ),
      link: link,
    );

    return unit;
  }

  /// We're setting a new instance to assign an authorization token. That way, we won't have
  /// to listen for the stream for setting the Authentication token
  void setAuthorizationToken(String token, String baseURL) {
    final httpLink = HttpLink(baseURL);
    final AuthLink authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );
    Link link = authLink.concat(httpLink);

    graphQLClient = GraphQLClient(
      cache: cache,
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
        watchQuery: Policies(fetch: FetchPolicy.noCache),
      ),
      link: link,
    );
  }

  TaskEither<Failure, Map<String, dynamic>> request({
    required String request,
    RequestType requestType = RequestType.query,
    Map<String, dynamic>? variables,
  }) => readGraphQLFile(request)
      .flatMap<QueryResult<Object?>>(
        (r) => doApiCall(
          request: r,
          variables: variables ?? {},
          requestType: requestType,
        ),
      )
      .chainEither(validateResponse)
      .map(getResponseData);

  /// This function is responsible for reading the GraphQL from the assets
  TaskEither<Failure, String> readGraphQLFile(String filePath) =>
      TaskEither.tryCatch(
        () => rootBundle.loadString(filePath),
        (error, stackTrace) => RequestMakingFaliure(),
      );

  /// With this function, users can make Query/Mutation request using
  /// only single function.
  TaskEither<Failure, QueryResult<Object?>> doApiCall({
    required String request,
    RequestType requestType = RequestType.query,
    Map<String, dynamic>? variables,
  }) => TaskEither.tryCatch(() {
    log('variables: $variables');
    switch (requestType) {
      case RequestType.query:
        final result = graphQLClient.query(
          QueryOptions(
            document: gql(request),
            variables: variables ?? {},
          ),
        );
        return result;
      case RequestType.mutation:
        final result = graphQLClient.mutate(
          MutationOptions(
            document: gql(request),
            variables: variables ?? {},
          ),
        );
        return result;
      case RequestType.get:
      case RequestType.post:
      case RequestType.delete:
      case RequestType.put:
        throw Exception('Not implemented');
    }
  }, APIFailure.new);

  /// Validate the response. Send error in case of exception
  Either<Failure, QueryResult<Object?>> validateResponse(
    QueryResult<Object?> response,
  ) => Either.fromPredicate(
    response,
    (response) => response.exception == null,
    (response) =>
        ResponseValidationFailure(error: response.exception),
  );

  /// Send response data after the sucessfull API call
  Map<String, dynamic> getResponseData(
    QueryResult<Object?> response,
  ) => response.data!;
}
