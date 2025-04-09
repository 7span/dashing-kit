import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

part 'user_model.g.dart';

/// This [UserModel] is also an Hive Adaptor so that we can easily implement
/// multiple accounts inside the same App.
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.profilePicUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['id'] as int,
      profilePicUrl: map['avatar'] as String,
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final int id;

  @HiveField(4)
  final String profilePicUrl;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'profilePicUrl': profilePicUrl,
    };
  }

  String toJson() => json.encode(toMap());
}
