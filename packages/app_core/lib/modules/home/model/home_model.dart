import 'package:app_core/modules/home/entity/reminder_entity.dart';

/// data : {"quickReplies":{"data":[{"id":113355,"name":"Greetings to Cavin","message":"Hey Cavin","media":null},{"id":113354,"name":"Send greeting to Milan","message":"Hey Milan Good evening","media":{"url":"https://app-whatshash-com.s3.ap-south-1.amazonaws.com/reply/cavin_dp.jpg?response-content-disposition=attachment&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAISKMBIXSUCXZC6UQ%2F20240123%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20240123T121726Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604800&X-Amz-Signature=a4b683c2fbc25c4536dcde4c08a857d69ee57127a82cce2459b0d5a0c795fb7e"}}]},"tickets":{"data":[{"id":1968,"dueDate":"2024-01-23","subject":"Dummy Subject 2","description":"Dummy Description 2","priority":"high","status":{"name":"Closed","color":"red"},"contact":{"id":"7530903","name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}},{"id":1967,"dueDate":"2024-01-25","subject":"Dummy Subject","description":"Dummy Description","priority":"medium","status":{"name":"Open","color":"green"},"contact":{"id":"7530903","name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}}]},"reminders":{"data":[{"id":111,"title":"New title","description":"New reminder description","remindAt":"1706111640","contact":{"name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}},{"id":110,"title":"New Reminder","description":"Dummy Description","remindAt":"1706021820","contact":{"name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}}]}}

// ignore_for_file: dangling_library_doc_comments, avoid_dynamic_calls, inference_failure_on_untyped_parameter

class HomeModel {
  HomeModel({this.data});

  HomeModel.fromJson(dynamic json) {
    data = json['data'] != null ? HomeData.fromJson(json['data']) : null;
  }
  HomeData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

/// quickReplies : {"data":[{"id":113355,"name":"Greetings to Cavin","message":"Hey Cavin","media":null},{"id":113354,"name":"Send greeting to Milan","message":"Hey Milan Good evening","media":{"url":"https://app-whatshash-com.s3.ap-south-1.amazonaws.com/reply/cavin_dp.jpg?response-content-disposition=attachment&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAISKMBIXSUCXZC6UQ%2F20240123%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20240123T121726Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604800&X-Amz-Signature=a4b683c2fbc25c4536dcde4c08a857d69ee57127a82cce2459b0d5a0c795fb7e"}}]}
/// tickets : {"data":[{"id":1968,"dueDate":"2024-01-23","subject":"Dummy Subject 2","description":"Dummy Description 2","priority":"high","status":{"name":"Closed","color":"red"},"contact":{"id":"7530903","name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}},{"id":1967,"dueDate":"2024-01-25","subject":"Dummy Subject","description":"Dummy Description","priority":"medium","status":{"name":"Open","color":"green"},"contact":{"id":"7530903","name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}}]}
/// reminders : {"data":[{"id":111,"title":"New title","description":"New reminder description","remindAt":"1706111640","contact":{"name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}},{"id":110,"title":"New Reminder","description":"Dummy Description","remindAt":"1706021820","contact":{"name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}}]}

class HomeData {
  HomeData({
    this.reminders,
  });

  HomeData.fromJson(dynamic json) {
    reminders = json['reminders'] != null ? Reminders.fromJson(json['reminders']) : null;
  }
  Reminders? reminders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (reminders != null) {
      map['reminders'] = reminders?.toJson();
    }
    return map;
  }
}

/// data : [{"id":111,"title":"New title","description":"New reminder description","remindAt":"1706111640","contact":{"name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}},{"id":110,"title":"New Reminder","description":"Dummy Description","remindAt":"1706021820","contact":{"name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}}]

class Reminders {
  Reminders({this.data});

  Reminders.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(RemindersData.fromJson(v));
      });
    }
  }
  List<RemindersData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 111
/// title : "New title"
/// description : "New reminder description"
/// remindAt : "1706111640"
/// contact : {"name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}

class RemindersData extends ReminderEntity {
  RemindersData({
    this.dataId,
    this.dataTitle,
    this.description,
    this.remindAt,
  }) : super(
          id: dataId,
          subTitle: description,
          title: dataTitle,
          reminderDate: remindAt,
        );

  factory RemindersData.fromJson(dynamic json) {
    return RemindersData(
      dataId: json['id'] as int?,
      dataTitle: json['title'] as String?,
      description: json['description'] as String?,
      remindAt: json['remindAt'] as String?,
    );
  }
  int? dataId;
  String? dataTitle;
  String? description;
  String? remindAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = dataId;
    map['title'] = dataTitle;
    map['description'] = description;
    map['remindAt'] = remindAt;
    return map;
  }
}

/// data : [{"id":1968,"dueDate":"2024-01-23","subject":"Dummy Subject 2","description":"Dummy Description 2","priority":"high","status":{"name":"Closed","color":"red"},"contact":{"id":"7530903","name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}},{"id":1967,"dueDate":"2024-01-25","subject":"Dummy Subject","description":"Dummy Description","priority":"medium","status":{"name":"Open","color":"green"},"contact":{"id":"7530903","name":"rur","mobileNumber":{"internationalFormat":"+91 535353535353"},"profilePicture":{"url":""}}}]
