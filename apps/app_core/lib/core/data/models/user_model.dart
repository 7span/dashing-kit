import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

/// This [UserModel] is also an Hive Adaptor so that we can easily implement
/// multiple accounts inside the same App.
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicUrl,
    required this.id,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      email: map['email'] as String,
      profilePicUrl: map['profilePicUrl'] as String,
      id: map['id'] as int,
    );
  }

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String profilePicUrl;

  @HiveField(5)
  final int id;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());
}
