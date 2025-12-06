
import 'dart:convert';

import '../../plan/model/plan_model.dart';

class MemberListApiResponseModel {
  String? status;
  String? message;
  List<MemberData>? data;
  Pagination? pagination;

  MemberListApiResponseModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  MemberListApiResponseModel copyWith({
    String? status,
    String? message,
    List<MemberData>? data,
    Pagination? pagination,
  }) =>
      MemberListApiResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory MemberListApiResponseModel.fromRawJson(String str) => MemberListApiResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MemberListApiResponseModel.fromJson(Map<String, dynamic> json) => MemberListApiResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<MemberData>.from(json["data"]!.map((x) => MemberData.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class MemberData {
  String? id;
  User? user;
  String? lounge;
  String? vibeDescription;
  bool? isActive;
  bool? isRequest;
  String? createdBy;
  String? createdByIp;
  DateTime? joinedAt;
  DateTime? createdAt;
  DateTime? updatedAt;


  MemberData({
    this.id,
    this.user,
    this.lounge,
    this.vibeDescription,
    this.isActive,
    this.isRequest,
    this.createdBy,
    this.createdByIp,
    this.joinedAt,
    this.createdAt,
    this.updatedAt,
  });

  MemberData copyWith({
    String? id,
    User? user,
    String? lounge,
    String? vibeDescription,
    bool? isActive,
    bool? isRequest,
    String? createdBy,
    String? createdByIp,
    DateTime? joinedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      MemberData(
        id: id ?? this.id,
        user: user ?? this.user,
        lounge: lounge ?? this.lounge,
        vibeDescription: vibeDescription ?? this.vibeDescription,
        isRequest: isRequest ?? this.isRequest,
        isActive: isActive ?? this.isActive,
        createdBy: createdBy ?? this.createdBy,
        createdByIp: createdByIp ?? this.createdByIp,
        joinedAt: joinedAt ?? this.joinedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory MemberData.fromRawJson(String str) => MemberData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MemberData.fromJson(Map<String, dynamic> json) => MemberData(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    lounge: json["lounge"],
    vibeDescription: json["vibeDescription"],
    isActive: json["isActive"],
    isRequest: json["isRequest"],
    createdBy: json["createdBy"],
    createdByIp: json["createdByIp"],
    joinedAt: json["joinedAt"] == null ? null : DateTime.parse(json["joinedAt"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user?.toJson(),
    "lounge": lounge,
    "vibeDescription": vibeDescription,
    "isActive": isActive,
    "isRequest": isRequest,
    "createdBy": createdBy,
    "createdByIp": createdByIp,
    "joinedAt": joinedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class User {
  String? id;
  String? name;
  String? email;
  String? avatar;
  DateTime? dob;
  int? age;
  bool? isActive;
  bool? isEmailVerified;
  String? cityName;

  User({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.dob,
    this.age,
    this.isActive,
    this.isEmailVerified,
    this.cityName
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    DateTime? dob,
    int? age,
    bool? isActive,
    bool? isEmailVerified,
    String?cityName
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        dob: dob ?? this.dob,
        age: age ?? this.age,
        isActive: isActive ?? this.isActive,
          isEmailVerified: isEmailVerified ?? this.isEmailVerified,
          cityName :cityName ?? this.cityName
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    avatar: json["avatar"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    age: json["age"],
    isActive: json["isActive"],
      isEmailVerified: json["isEmailVerified"],
      cityName:json["city"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "avatar": avatar,
    "dob": dob?.toIso8601String(),
    "age": age,
    "isActive": isActive,
    "isEmailVerified": isEmailVerified,
    "city":cityName
  };
}


