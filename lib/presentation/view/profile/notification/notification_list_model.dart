
import 'dart:convert';

import '../../plan/model/plan_model.dart';

class NotificationListModel {
  String? status;
  String? message;
  NotificationListModelData? data;

  NotificationListModel({
    this.status,
    this.message,
    this.data,
  });

  NotificationListModel copyWith({
    String? status,
    String? message,
    NotificationListModelData? data,
  }) =>
      NotificationListModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory NotificationListModel.fromRawJson(String str) => NotificationListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : NotificationListModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class NotificationListModelData {
  List<NotificationDetails>? notifications;
  Pagination? pagination;
  int? unreadCount;

  NotificationListModelData({
    this.notifications,
    this.pagination,
    this.unreadCount,
  });

  NotificationListModelData copyWith({
    List<NotificationDetails>? notifications,
    Pagination? pagination,
    int? unreadCount,
  }) =>
      NotificationListModelData(
        notifications: notifications ?? this.notifications,
        pagination: pagination ?? this.pagination,
        unreadCount: unreadCount ?? this.unreadCount,
      );

  factory NotificationListModelData.fromRawJson(String str) => NotificationListModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationListModelData.fromJson(Map<String, dynamic> json) => NotificationListModelData(
    notifications: json["notifications"] == null ? [] : List<NotificationDetails>.from(json["notifications"]!.map((x) => NotificationDetails.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    unreadCount: json["unreadCount"],
  );

  Map<String, dynamic> toJson() => {
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
    "unreadCount": unreadCount,
  };
}

class NotificationDetails {
  String? id;
  String? user;
  String? type;
  String? title;
  String? message;
  String? image;
  String? relatedId;
  String? relatedName;
  bool? isRead;
  bool? pushSent;
  dynamic pushSentAt;
  NotificationData? data;
  String? priority;
  DateTime? createdAt;
  DateTime? updatedAt;

  NotificationDetails({
    this.id,
    this.user,
    this.type,
    this.title,
    this.message,
    this.image,
    this.relatedId,
    this.relatedName,
    this.isRead,
    this.pushSent,
    this.pushSentAt,
    this.data,
    this.priority,
    this.createdAt,
    this.updatedAt,
  });

  NotificationDetails copyWith({
    String? id,
    String? user,
    String? type,
    String? title,
    String? message,
    String? image,
    String? relatedId,
    String? relatedName,
    bool? isRead,
    bool? pushSent,
    dynamic pushSentAt,
    NotificationData? data,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      NotificationDetails(
        id: id ?? this.id,
        user: user ?? this.user,
        type: type ?? this.type,
        title: title ?? this.title,
        message: message ?? this.message,
        image: image ?? this.image,
        relatedId: relatedId ?? this.relatedId,
        relatedName: relatedName ?? this.relatedName,
        isRead: isRead ?? this.isRead,
        pushSent: pushSent ?? this.pushSent,
        pushSentAt: pushSentAt ?? this.pushSentAt,
        data: data ?? this.data,
        priority: priority ?? this.priority,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory NotificationDetails.fromRawJson(String str) => NotificationDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationDetails.fromJson(Map<String, dynamic> json) => NotificationDetails(
    id: json["_id"],
    user: json["user"],
    type: json["type"],
    title: json["title"],
    message: json["message"],
    image: json["image"],
    relatedId: json["relatedId"],
    relatedName: json["relatedName"],
    isRead: json["isRead"],
    pushSent: json["pushSent"],
    pushSentAt: json["pushSentAt"],
    data: json["data"] == null ? null : NotificationData.fromJson(json["data"]),
    priority: json["priority"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "type": type,
    "title": title,
    "message": message,
    "image": image,
    "relatedId": relatedId,
    "relatedName": relatedName,
    "isRead": isRead,
    "pushSent": pushSent,
    "pushSentAt": pushSentAt,
    "data": data?.toJson(),
    "priority": priority,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class NotificationData {
  String? matchedUserId;
  String? matchedUserName;
  String? matchedUserAvatar;

  NotificationData({
    this.matchedUserId,
    this.matchedUserName,
    this.matchedUserAvatar,
  });

  NotificationData copyWith({
    String? matchedUserId,
    String? matchedUserName,
    String? matchedUserAvatar,
  }) =>
      NotificationData(
        matchedUserId: matchedUserId ?? this.matchedUserId,
        matchedUserName: matchedUserName ?? this.matchedUserName,
        matchedUserAvatar: matchedUserAvatar ?? this.matchedUserAvatar,
      );

  factory NotificationData.fromRawJson(String str) => NotificationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    matchedUserId: json["matchedUserId"],
    matchedUserName: json["matchedUserName"],
    matchedUserAvatar: json["matchedUserAvatar"],
  );

  Map<String, dynamic> toJson() => {
    "matchedUserId": matchedUserId,
    "matchedUserName": matchedUserName,
    "matchedUserAvatar": matchedUserAvatar,
  };
}

