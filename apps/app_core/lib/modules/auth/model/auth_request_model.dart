class AuthRequestModel {
  AuthRequestModel({
    this.email,
    this.name,
    this.password,
    this.avatar,
  });

  String? email;
  String? name;
  String? password;
  String? avatar;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['avatar'] = avatar;
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}
