class AuthResponseModel {
  AuthResponseModel({this.authToken, this.message, this.id});

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    return AuthResponseModel(
      authToken: map['token'] as String?,
      message: map['message'] as String?,
      id: map['id'] as String?,
    );
  }

  String? authToken;
  String? message;
  String? id;
}
