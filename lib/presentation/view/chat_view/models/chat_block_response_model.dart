
import 'dart:convert';

class ChatBlockStatusResponseModel {
  String? status;
  String? message;
  ChatBlockedResponseData? data;

  ChatBlockStatusResponseModel({
    this.status,
    this.message,
    this.data,
  });

  ChatBlockStatusResponseModel copyWith({
    String? status,
    String? message,
    ChatBlockedResponseData? data,
  }) =>
      ChatBlockStatusResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ChatBlockStatusResponseModel.fromRawJson(String str) => ChatBlockStatusResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatBlockStatusResponseModel.fromJson(Map<String, dynamic> json) => ChatBlockStatusResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : ChatBlockedResponseData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class ChatBlockedResponseData {
  String? chatId;
  bool? isBlocked;
  String? blockedBy;
  String? blockedAt;

  ChatBlockedResponseData({
    this.chatId,
    this.isBlocked,
    this.blockedBy,
    this.blockedAt,
  });

  ChatBlockedResponseData copyWith({
    String? chatId,
    bool? isBlocked,
    String? blockedBy,
    String? blockedAt,
  }) =>
      ChatBlockedResponseData(
        chatId: chatId ?? this.chatId,
        isBlocked: isBlocked ?? this.isBlocked,
        blockedBy: blockedBy ?? this.blockedBy,
        blockedAt: blockedAt ?? this.blockedAt,
      );

  factory ChatBlockedResponseData.fromRawJson(String str) => ChatBlockedResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatBlockedResponseData.fromJson(Map<String, dynamic> json) => ChatBlockedResponseData(
    chatId: json["chatId"],
    isBlocked: json["isBlocked"],
    blockedBy: json["blockedBy"],
    blockedAt: json["blockedAt"] ,
  );

  Map<String, dynamic> toJson() => {
    "chatId": chatId,
    "isBlocked": isBlocked,
    "blockedBy": blockedBy,
    "blockedAt": blockedAt,
  };
}
