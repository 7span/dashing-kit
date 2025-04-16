class RefreshTokenDTO {
  RefreshTokenDTO({this.message, this.data});

  factory RefreshTokenDTO.fromMap(Map<String, dynamic> map) {
    return RefreshTokenDTO(
      message: map['message'] as String?,
      data:
          map['data'] != null
              ? RefreshTokenResponseModel.fromMap(
                map['data'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {'message': message, 'data': data};
  }

  final String? message;
  final RefreshTokenResponseModel? data;
}

class RefreshTokenResponseModel {
  RefreshTokenResponseModel({this.token, this.refreshToken});

  factory RefreshTokenResponseModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return RefreshTokenResponseModel(
      token: map['token'] as String?,
      refreshToken: map['refreshToken'] as String?,
    );
  }

  final String? token;
  final String? refreshToken;

  Map<String, dynamic> toMap() {
    return {'token': token, 'refreshToken': refreshToken};
  }
}
