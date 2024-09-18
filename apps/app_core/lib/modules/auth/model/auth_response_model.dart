class AuthResponseModel {
  AuthResponseModel({
    this.authToken,
    this.message,
    this.id,
    /* this.userDetails*/
  });

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    return AuthResponseModel(
      authToken: map['access_token'] as String?,
      message: map['message'] as String?,
      id: map['id'] as int?,
      // userDetails: map['userDetails'] as UserDetails?,
    );
  }

  String? authToken;
  String? message;
  int? id;
// UserDetails? userDetails;
}
