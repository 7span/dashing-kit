// ignore_for_file: one_member_abstracts

import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_core/core/data/repository-utils/repository_utils.dart';
import 'package:app_core/modules/home/model/user_list_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UserRepository {
  TaskEither<Failure, UserListModel> fetchUsers({required int page});
}

class MockUserRepository implements UserRepository {
  @override
  TaskEither<Failure, UserListModel> fetchUsers({required int page}) {
    return TaskEither.tryCatch(
      () async => _fetchUsers(page: page, limit: 5),
      APIFailure.new,
    );
  }

  Future<UserListModel> _fetchUsers({
    required int page,
    required int limit,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Mock data: Each page fetches [limit] users
    const allUsers = [
      'Alice',
      'Bob',
      'Charlie',
      'Diana',
      'Eve',
      'Frank',
      'Grace',
      'Hank',
      'Ivy',
      'Jack',
      'Kathy',
      'Leo',
      'Mia',
      'Nina',
      'Oscar',
      'Alice',
      'Bob',
      'Charlie',
      'Diana',
      'Eve',
      'Frank',
      'Grace',
      'Hank',
      'Ivy',
      'Jack',
      'Kathy',
      'Leo',
      'Mia',
      'Nina',
      'Oscar',
      'Alice',
      'Bob',
      'Charlie',
      'Diana',
      'Eve',
      'Frank',
      'Grace',
      'Hank',
      'Ivy',
      'Jack',
      'Kathy',
      'Leo',
      'Mia',
      'Nina',
      'Oscar',
      'Alice',
      'Bob',
      'Charlie',
      'Diana',
      'Eve',
      'Frank',
      'Grace',
      'Hank',
      'Ivy',
      'Jack',
      'Kathy',
      'Leo',
      'Mia',
      'Nina',
      'Oscar',
    ];

    final startIndex = (page - 1) * limit;
    final paginatedData =
        startIndex >= allUsers.length
            ? <String>[]
            : allUsers.skip(startIndex).take(limit).toList();
    return UserListModel()
      ..page = page
      ..perPage = limit
      ..total = allUsers.length
      ..totalPages = (allUsers.length + limit - 1) ~/ limit
      ..data = paginatedData.map((e) => Data(firstName: e)).toList();
  }
}

class ApiUserRepository implements UserRepository {
  @override
  TaskEither<Failure, UserListModel> fetchUsers({required int page}) {
    return makefetchUsersRequest(page)
        .chainEither(RepositoryUtils.checkStatusCode)
        .chainEither(
          (r) => RepositoryUtils.mapToModel(
            () => UserListModel.fromJson(r.data as Map<String, dynamic>),
          ),
        );
  }

  TaskEither<Failure, Response> makefetchUsersRequest(int page) {
    return RestApiClient.request(path: 'users?page=$page&per_page=5');
  }
}
