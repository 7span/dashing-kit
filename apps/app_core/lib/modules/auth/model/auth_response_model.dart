class AuthResponseModel {
  AuthResponseModel({
    required this.email,
    required this.id,
    this.name,
    this.avatar,
  });

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    return AuthResponseModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      avatar: map['avatar'] as String?,
    );
  }

  String? name;
  String id;
  String email;
  String? avatar;
}
