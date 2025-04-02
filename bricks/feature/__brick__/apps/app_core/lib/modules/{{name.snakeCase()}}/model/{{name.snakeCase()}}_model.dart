class {{name.pascalCase()}}Model {
  {{name.pascalCase()}}Model({required this.id});

  factory {{name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) {
    return {{name.pascalCase()}}Model(id: json['id'] as String);
  }
  final String id;

  Map<String, dynamic> toJson({{name.pascalCase()}}Model {{name.snakeCase()}}Model) {
    return {'id': {{name.snakeCase()}}Model.id};
  }
}
