

import 'dart:convert';

import '../../plan/model/plan_model.dart';

class MyMatchesListResponseModel {
  String? status;
  String? message;
  Data? data;

  MyMatchesListResponseModel({
    this.status,
    this.message,
    this.data,
  });

  MyMatchesListResponseModel copyWith({
    String? status,
    String? message,
    Data? data,
  }) =>
      MyMatchesListResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MyMatchesListResponseModel.fromRawJson(String str) => MyMatchesListResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyMatchesListResponseModel.fromJson(Map<String, dynamic> json) => MyMatchesListResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  List<MatchData>? matches;
  PaginationHasMore? pagination;

  Data({
    this.matches,
    this.pagination,
  });

  Data copyWith({
    List<MatchData>? matches,
    PaginationHasMore? pagination,
  }) =>
      Data(
        matches: matches ?? this.matches,
        pagination: pagination ?? this.pagination,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    matches: json["matches"] == null ? [] : List<MatchData>.from(json["matches"]!.map((x) => MatchData.fromJson(x))),
    pagination: json["pagination"] == null ? null : PaginationHasMore.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "matches": matches == null ? [] : List<dynamic>.from(matches!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class MatchData {
  String? matchId;
  MatchUser? requester;
  MatchUser? requestee;
  MatchUser? user;
  String? status;
  bool? isMatched;
  dynamic matchedAt;
  DateTime?createdAt;
  String? message;
  String? chatId;
  int? unreadMessageCount;
  UnblurRequestData?unblurRequest;

  MatchData({
    this.matchId,
    this.user,
    this.requester,
    this.requestee,
    this.status,
    this.isMatched,
    this.matchedAt,
    this.createdAt,
    this.message,
    this.chatId,
    this.unreadMessageCount,
    this.unblurRequest,
  });

  MatchData copyWith({
    String? matchId,
    MatchUser? user,
    MatchUser? requester,
    MatchUser? requestee,
    String? status,
    bool? isMatched,
    dynamic matchedAt,
    DateTime?createdAt,
    String? message,
    int? unreadMessageCount,
    String? chatId,
    UnblurRequestData?unblurRequest
  }) =>
      MatchData(
        matchId: matchId ?? this.matchId,
        user: user ?? this.user,
        requester: requester ?? this.requester,
        requestee: requestee ?? this.requestee,
        status: status ?? this.status,
        isMatched: isMatched ?? this.isMatched,
          createdAt: createdAt ?? this.createdAt,
        matchedAt: matchedAt ?? this.matchedAt,
        message: message ?? this.message,
        chatId: chatId ?? this.chatId,
          unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
          unblurRequest:unblurRequest??this.unblurRequest
      );

  factory MatchData.fromRawJson(String str) => MatchData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
    matchId: json["matchId"],
    user: json["user"] == null ? null : MatchUser.fromJson(json["user"]),
    requester: json["requester"] == null ? null : MatchUser.fromJson(json["requester"]),
    requestee: json["requestee"] == null ? null : MatchUser.fromJson(json["requestee"]),
    unblurRequest: json["unblurRequest"] == null ? null : UnblurRequestData.fromJson(json["unblurRequest"]),
    status: json["status"],
    isMatched: json["isMatched"],
    matchedAt: json["matchedAt"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    unreadMessageCount: json["unreadMessageCount"],
    message: json["message"],
    chatId: json["chatId"],
  );

  Map<String, dynamic> toJson() => {
    "matchId": matchId,
    "user": user?.toJson(),
    "requestee": requestee?.toJson(),
    "requester": requester?.toJson(),
    "unblurRequest": unblurRequest?.toJson(),
    "status": status,
    "isMatched": isMatched,
    "matchedAt": matchedAt,
    "createdAt": createdAt,

    "unreadMessageCount": unreadMessageCount,
    "message": message,
    "chatId": chatId,

  };
}

class MatchUser {
  String? id;
  String? name;
  String? avatar;
  String? city;
  int? age;
  dynamic bio;
  DateTime? lastActive;

  MatchUser({
    this.id,
    this.name,
    this.avatar,
    this.city,
    this.age,
    this.bio,
    this.lastActive,
  });

  MatchUser copyWith({
    String? id,
    String? name,
    String? avatar,
    String? city,
    int? age,
    dynamic bio,
    DateTime? lastActive,
  }) =>
      MatchUser(
        id: id ?? this.id,
        name: name ?? this.name,
        city: city ?? this.city,
        avatar: avatar ?? this.avatar,
        age: age ?? this.age,
        bio: bio ?? this.bio,
        lastActive: lastActive ?? this.lastActive,
      );

  factory MatchUser.fromRawJson(String str) => MatchUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MatchUser.fromJson(Map<String, dynamic> json) => MatchUser(
    id: json["_id"],
    name: json["name"],
    avatar: json["avatar"],
    city: json["city"],
    age: json["age"],
    bio: json["bio"],
    lastActive: json["lastActive"] == null ? null : DateTime.parse(json["lastActive"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "avatar": avatar,
    "city": city,
    "age": age,
    "bio": bio,
    "lastActive": lastActive?.toIso8601String(),
  };
}





class UnblurRequestData {
  String? id;
  String? requestedBy;
  String? requestedTo;
  String? matchId;
  int? unblurCreditAmount;
  String? status;
  dynamic processedAt;
  dynamic denialReason;
  dynamic expiresAt;
  bool? isActive;
  String? transactionId;
  DateTime? createdAt;
  DateTime? updatedAt;

  UnblurRequestData({
    this.id,
    this.requestedBy,
    this.requestedTo,
    this.matchId,
    this.unblurCreditAmount,
    this.status,
    this.processedAt,
    this.denialReason,
    this.expiresAt,
    this.isActive,
    this.transactionId,
    this.createdAt,
    this.updatedAt,
  });

  UnblurRequestData copyWith({
    String? id,
    String? requestedBy,
    String? requestedTo,
    String? matchId,
    int? unblurCreditAmount,
    String? status,
    dynamic processedAt,
    dynamic denialReason,
    dynamic expiresAt,
    bool? isActive,
    String? transactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UnblurRequestData(
        id: id ?? this.id,
        requestedBy: requestedBy ?? this.requestedBy,
        requestedTo: requestedTo ?? this.requestedTo,
        matchId: matchId ?? this.matchId,
        unblurCreditAmount: unblurCreditAmount ?? this.unblurCreditAmount,
        status: status ?? this.status,
        processedAt: processedAt ?? this.processedAt,
        denialReason: denialReason ?? this.denialReason,
        expiresAt: expiresAt ?? this.expiresAt,
        isActive: isActive ?? this.isActive,
        transactionId: transactionId ?? this.transactionId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UnblurRequestData.fromRawJson(String str) => UnblurRequestData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UnblurRequestData.fromJson(Map<String, dynamic> json) => UnblurRequestData(
    id: json["_id"],
    requestedBy: json["requestedBy"],
    requestedTo: json["requestedTo"],
    matchId: json["matchId"],
    unblurCreditAmount: json["unblurCreditAmount"],
    status: json["status"],
    processedAt: json["processedAt"],
    denialReason: json["denialReason"],
    expiresAt: json["expiresAt"],
    isActive: json["isActive"],
    transactionId: json["transactionId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "requestedBy": requestedBy,
    "requestedTo": requestedTo,
    "matchId": matchId,
    "unblurCreditAmount": unblurCreditAmount,
    "status": status,
    "processedAt": processedAt,
    "denialReason": denialReason,
    "expiresAt": expiresAt,
    "isActive": isActive,
    "transactionId": transactionId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
