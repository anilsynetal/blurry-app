
import 'dart:convert';

class ReportReasonListModel {
  String? status;
  String? message;
  Data? data;

  ReportReasonListModel({
    this.status,
    this.message,
    this.data,
  });

  ReportReasonListModel copyWith({
    String? status,
    String? message,
    Data? data,
  }) =>
      ReportReasonListModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ReportReasonListModel.fromRawJson(String str) => ReportReasonListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReportReasonListModel.fromJson(Map<String, dynamic> json) => ReportReasonListModel(
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
  List<ReportReason>? reasons;

  Data({
    this.reasons,
  });

  Data copyWith({
    List<ReportReason>? reasons,
  }) =>
      Data(
        reasons: reasons ?? this.reasons,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    reasons: json["reasons"] == null ? [] : List<ReportReason>.from(json["reasons"]!.map((x) => ReportReason.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "reasons": reasons == null ? [] : List<dynamic>.from(reasons!.map((x) => x.toJson())),
  };
}

class ReportReason {
  String? value;
  String? label;

  ReportReason({
    this.value,
    this.label,
  });

  ReportReason copyWith({
    String? value,
    String? label,
  }) =>
      ReportReason(
        value: value ?? this.value,
        label: label ?? this.label,
      );

  factory ReportReason.fromRawJson(String str) => ReportReason.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReportReason.fromJson(Map<String, dynamic> json) => ReportReason(
    value: json["value"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
  };
}
