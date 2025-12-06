
import 'dart:convert';

import '../../plan/model/plan_model.dart';

class GetLoungesListResponseModel {
  String? status;
  String? message;
  List<LoungesData>? data;
  Pagination? pagination;

  GetLoungesListResponseModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  GetLoungesListResponseModel copyWith({
    String? status,
    String? message,
    List<LoungesData>? data,
    Pagination? pagination,
  }) =>
      GetLoungesListResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory GetLoungesListResponseModel.fromRawJson(String str) => GetLoungesListResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetLoungesListResponseModel.fromJson(Map<String, dynamic> json) => GetLoungesListResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<LoungesData>.from(json["data"]!.map((x) => LoungesData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class LoungesData {
  String? id;
  String? name;
  String? description;
  String? image;
  String? bannerImage;
  List<String>? tags;
  bool? isActive;
  int? sortOrder;
  String? createdBy;
  String? createdByIp;
  String? updatedByIp;
  DateTime? createdAt;
  String? updatedAt;
  String? updatedBy;
  bool? isJoined;

  LoungesData({
    this.id,
    this.name,
    this.description,
    this.image,
    this.bannerImage,
    this.tags,
    this.isActive,
    this.sortOrder,
    this.createdBy,
    this.createdByIp,
    this.updatedByIp,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.isJoined,
  });

  LoungesData copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? bannerImage,
    List<String>? tags,
    bool? isActive,
    int? sortOrder,
    String? createdBy,
    String? createdByIp,
    String? updatedByIp,
    DateTime? createdAt,
    String? updatedAt,
    String? updatedBy,
    bool? isJoined,
  }) =>
      LoungesData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        bannerImage: bannerImage ?? this.bannerImage,
        tags: tags ?? this.tags,
        isActive: isActive ?? this.isActive,
        sortOrder: sortOrder ?? this.sortOrder,
        createdBy: createdBy ?? this.createdBy,
        createdByIp: createdByIp ?? this.createdByIp,
        updatedByIp: updatedByIp ?? this.updatedByIp,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        isJoined: isJoined ?? this.isJoined,
      );

  factory LoungesData.fromRawJson(String str) => LoungesData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoungesData.fromJson(Map<String, dynamic> json) => LoungesData(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    bannerImage: json["bannerImage"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    isActive: json["isActive"],
    sortOrder: json["sortOrder"],
    createdBy: json["createdBy"],
    createdByIp: json["createdByIp"],
    updatedByIp: json["updatedByIp"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"],
    updatedBy: json["updatedBy"],
    isJoined: json["isJoined"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "image": image,
    "bannerImage": bannerImage,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "isActive": isActive,
    "sortOrder": sortOrder,
    "createdBy": createdBy,
    "createdByIp": createdByIp,
    "updatedByIp": updatedByIp,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt,
    "updatedBy": updatedBy,
    "isJoined": isJoined,
  };
}