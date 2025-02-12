// ignore_for_file: avoid_dynamic_calls

class UserListModel {
  UserListModel({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    List<Data>? data,
    this.support,
  }) : data = data ?? [];

  UserListModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    data = [];
    if (json['data'] != null) {
      // ignore: inference_failure_on_untyped_parameter
      json['data'].forEach((item) {
        data.add(Data.fromJson(item));
      });
    }
    support = json['support'] != null ? Support.fromJson(json['support']) : null;
  }

  num? page;
  num? perPage;
  num? total;
  num? totalPages;
  late List<Data> data;
  Support? support;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['per_page'] = perPage;
    map['total'] = total;
    map['total_pages'] = totalPages;
    map['data'] = data.map((v) => v.toJson()).toList();
    if (support != null) {
      map['support'] = support?.toJson();
    }
    return map;
  }
}

class Support {
  Support({this.url, this.text});

  Support.fromJson(dynamic json) {
    url = json['url'];
    text = json['text'];
  }

  String? url;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['text'] = text;
    return map;
  }
}

class Data {
  Data({this.id, this.email, this.firstName, this.lastName, this.avatar});

  Data.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
  }

  num? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['avatar'] = avatar;
    return map;
  }
}
