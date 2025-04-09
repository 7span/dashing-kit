import 'package:app_core/core/data/models/pagination_model.dart';

class {{name.pascalCase()}}ResponseModel {
  const {{name.pascalCase()}}ResponseModel(this.{{name.camelCase()}});

  factory {{name.pascalCase()}}ResponseModel.fromJson(Map<String, dynamic> json) {
    return {{name.pascalCase()}}ResponseModel({{name.pascalCase()}}.fromJson(json['{{name.camelCase()}}s']));
  }

  final {{name.pascalCase()}}? {{name.camelCase()}};

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if ({{name.camelCase()}} != null) {
      data['{{name.camelCase()}}'] = {{name.camelCase()}}!.toJson();
    }
    return data;
  }
}

class {{name.pascalCase()}} {
  {{name.pascalCase()}}({this.data, this.pagination});

  {{name.pascalCase()}}.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = <{{name.pascalCase()}}Model>[];
      // ignore: inference_failure_on_untyped_parameter
      json['data'].forEach((v) {
        data!.add({{name.pascalCase()}}Model.fromJson(v));
      });
    }
    pagination =
        json['pagination'] != null
            ? PaginationModel.fromJson(json['pagination'])
            : null;
  }

  List<{{name.pascalCase()}}Model>? data;
  PaginationModel? pagination;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

// ignore: must_be_immutable
class {{name.pascalCase()}}Model {
  {{name.pascalCase()}}Model({this.dataId, this.title, this.description});

  factory {{name.pascalCase()}}Model.fromJson(dynamic json) => {{name.pascalCase()}}Model(
    dataId: json['id'] as int?,
    title: json['title'] as String?,
    description: json['description'] as String?,
  );

  int? dataId;
  String? title;
  String? description;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = dataId;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
