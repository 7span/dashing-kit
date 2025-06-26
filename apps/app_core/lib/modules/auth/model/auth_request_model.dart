class AuthRequestModel {
  AuthRequestModel({
    this.email,
    this.name,
    this.password,
    this.avatar,
    this.provider,
    this.providerId,
    this.providerToken,
    this.oneSignalPlayerId,
  });

  AuthRequestModel.verifyOTP({required this.email, required this.token});

  AuthRequestModel.forgotPassword({required this.email});

  String? email;
  String? name;
  String? password;
  String? avatar;
  String? provider;
  String? providerId;
  String? providerToken;
  String? oneSignalPlayerId;
  String? token;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['avatar'] = avatar;
    map['email'] = email;
    map['password'] = password;
    return map;
  }

  Map<String, dynamic> toVerifyOTPMap() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['token'] = token;
    return map;
  }

  Map<String, dynamic> toSocialSignInMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['avatar'] = avatar;
    map['email'] = email;
    map['password'] = password;
    map['provider'] = provider;
    map['providerId'] = providerId;
    map['providerToken'] = providerToken;
    map['oneSignalPlayerId'] = oneSignalPlayerId;
    return map;
  }

  Map<String, dynamic> toForgotPasswordMap() {
    final map = <String, dynamic>{};
    map['email'] = email;
    return map;
  }
}
