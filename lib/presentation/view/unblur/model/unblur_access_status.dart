
import 'dart:convert';

class UnblurAccessCheckModel {
  String? status;
  String? message;
  UnblurAccessCheckData? data;

  UnblurAccessCheckModel({
    this.status,
    this.message,
    this.data,
  });

  UnblurAccessCheckModel copyWith({
    String? status,
    String? message,
    UnblurAccessCheckData? data,
  }) =>
      UnblurAccessCheckModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory UnblurAccessCheckModel.fromRawJson(String str) => UnblurAccessCheckModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UnblurAccessCheckModel.fromJson(Map<String, dynamic> json) => UnblurAccessCheckModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : UnblurAccessCheckData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class UnblurAccessCheckData {
  bool? hasAccess;
  String? expiresAt;
  String? requestId;
  String? transactionId;

  UnblurAccessCheckData({
    this.hasAccess,
    this.expiresAt,
    this.requestId,
    this.transactionId,
  });

  UnblurAccessCheckData copyWith({
    bool? hasAccess,
    String? expiresAt,
    String? requestId,
    String? transactionId,
  }) =>
      UnblurAccessCheckData(
        hasAccess: hasAccess ?? this.hasAccess,
        expiresAt: expiresAt ?? this.expiresAt,
        requestId: requestId ?? this.requestId,
        transactionId: transactionId ?? this.transactionId,
      );

  factory UnblurAccessCheckData.fromRawJson(String str) => UnblurAccessCheckData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UnblurAccessCheckData.fromJson(Map<String, dynamic> json) => UnblurAccessCheckData(
    hasAccess: json["hasAccess"],
    expiresAt: json["expiresAt"] ,
    requestId: json["requestId"],
    transactionId: json["transactionId"],
  );

  Map<String, dynamic> toJson() => {
    "hasAccess": hasAccess,
    "expiresAt": expiresAt,
    "requestId": requestId,
    "transactionId": transactionId,
  };
}
