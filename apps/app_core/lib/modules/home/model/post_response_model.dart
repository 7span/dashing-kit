import 'package:flutter/foundation.dart';

class PostResponseModel {
  const PostResponseModel({this.userId, this.id, this.title, this.body});

  factory PostResponseModel.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print('Hello : $json');
    }
    return PostResponseModel(
      userId: json['userId'] as int?,
      id: json['id'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?,
    );
  }
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  Map<String, dynamic> toJson(PostResponseModel postResponseModel) {
    return {
      'userId': postResponseModel.userId,
      'id': postResponseModel.id,
      'title': postResponseModel.title,
      'body': postResponseModel.body,
    };
  }
}
