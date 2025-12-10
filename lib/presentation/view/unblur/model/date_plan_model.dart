import 'dart:convert';

import '../../plan/model/plan_model.dart';

class DatePlanListResponseModel {
  String? status;
  String? message;
  List<DatePlanData>? data;
  Pagination? pagination;

  DatePlanListResponseModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  DatePlanListResponseModel copyWith({
    String? status,
    String? message,
    List<DatePlanData>? data,
    Pagination? pagination,
  }) =>
      DatePlanListResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory DatePlanListResponseModel.fromRawJson(String str) => DatePlanListResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatePlanListResponseModel.fromJson(Map<String, dynamic> json) => DatePlanListResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DatePlanData>.from(json["data"]!.map((x) => DatePlanData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class DatePlanData {
  String? id;
  String? title;
  String? description;
  String? type;
  String? costType;
  String? templateImage;
  String? icon;
  bool? isActive;
  int? sortOrder;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? updatedBy;
  String? updatedByIp;

  DatePlanData({
    this.id,
    this.title,
    this.description,
    this.type,
    this.costType,
    this.templateImage,
    this.icon,
    this.isActive,
    this.sortOrder,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.updatedByIp,
  });

  DatePlanData copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? costType,
    String? templateImage,
    String? icon,
    bool? isActive,
    int? sortOrder,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? updatedBy,
    String? updatedByIp,
  }) =>
      DatePlanData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        type: type ?? this.type,
        costType: costType ?? this.costType,
        templateImage: templateImage ?? this.templateImage,
        icon: icon ?? this.icon,
        isActive: isActive ?? this.isActive,
        sortOrder: sortOrder ?? this.sortOrder,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        updatedByIp: updatedByIp ?? this.updatedByIp,
      );

  factory DatePlanData.fromRawJson(String str) => DatePlanData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatePlanData.fromJson(Map<String, dynamic> json) => DatePlanData(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    type: json["type"],
    costType: json["costType"],
    templateImage: json["templateImage"],
    icon: json["icon"],
    isActive: json["isActive"],
    sortOrder: json["sortOrder"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    updatedBy: json["updatedBy"],
    updatedByIp: json["updatedByIp"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "type": type,
    "costType": costType,
    "templateImage": templateImage,
    "icon": icon,
    "isActive": isActive,
    "sortOrder": sortOrder,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "updatedBy": updatedBy,
    "updatedByIp": updatedByIp,
  };
}

