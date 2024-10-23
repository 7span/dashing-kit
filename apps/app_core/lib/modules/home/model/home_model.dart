class HomeModel {

  const HomeModel({
    this.id,
    this.email,
    this.name,
    this.avatar,
    this.role,
  });

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      id: map['id'] as int?,
      email: map['email'] as String?,
      name: map['name'] as String?,
      avatar: map['avatar'] as String?,
      role: map['role'] as String?,
    );
  }

 final int? id;
 final String? email;
 final String? name;
 final String? avatar;
 final String? role;
}
