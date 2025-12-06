
import 'dart:convert';

class InviteDetailsResponse {
  String? status;
  String? message;
  InviteData? data;

  InviteDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  InviteDetailsResponse copyWith({
    String? status,
    String? message,
    InviteData? data,
  }) =>
      InviteDetailsResponse(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory InviteDetailsResponse.fromRawJson(String str) => InviteDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InviteDetailsResponse.fromJson(Map<String, dynamic> json) => InviteDetailsResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : InviteData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class InviteData {
  String? inviteCode;
  int? referralCreditsEarned;
  int? totalReferrals;
  int? successfulReferrals;
  InvitationConfig? invitationConfig;

  InviteData({
    this.inviteCode,
    this.referralCreditsEarned,
    this.totalReferrals,
    this.successfulReferrals,
    this.invitationConfig,
  });

  InviteData copyWith({
    String? inviteCode,
    int? referralCreditsEarned,
    int? totalReferrals,
    int? successfulReferrals,
    InvitationConfig? invitationConfig,
  }) =>
      InviteData(
        inviteCode: inviteCode ?? this.inviteCode,
        referralCreditsEarned: referralCreditsEarned ?? this.referralCreditsEarned,
        totalReferrals: totalReferrals ?? this.totalReferrals,
        successfulReferrals: successfulReferrals ?? this.successfulReferrals,
        invitationConfig: invitationConfig ?? this.invitationConfig,
      );

  factory InviteData.fromRawJson(String str) => InviteData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InviteData.fromJson(Map<String, dynamic> json) => InviteData(
    inviteCode: json["inviteCode"],
    referralCreditsEarned: json["referralCreditsEarned"],
    totalReferrals: json["totalReferrals"],
    successfulReferrals: json["successfulReferrals"],
    invitationConfig: json["invitationConfig"] == null ? null : InvitationConfig.fromJson(json["invitationConfig"]),
  );

  Map<String, dynamic> toJson() => {
    "inviteCode": inviteCode,
    "referralCreditsEarned": referralCreditsEarned,
    "totalReferrals": totalReferrals,
    "successfulReferrals": successfulReferrals,
    "invitationConfig": invitationConfig?.toJson(),
  };
}

class InvitationConfig {
  String? title;
  String? description;
  int? referrerCreditAmount;
  int? referredCreditAmount;
  bool? isEnabled;
  String? bannerImage;

  InvitationConfig({
    this.title,
    this.description,
    this.referrerCreditAmount,
    this.referredCreditAmount,
    this.isEnabled,
    this.bannerImage,
  });

  InvitationConfig copyWith({
    String? title,
    String? description,
    int? referrerCreditAmount,
    int? referredCreditAmount,
    bool? isEnabled,
    String? bannerImage,
  }) =>
      InvitationConfig(
        title: title ?? this.title,
        description: description ?? this.description,
        referrerCreditAmount: referrerCreditAmount ?? this.referrerCreditAmount,
        referredCreditAmount: referredCreditAmount ?? this.referredCreditAmount,
        isEnabled: isEnabled ?? this.isEnabled,
        bannerImage: bannerImage ?? this.bannerImage,
      );

  factory InvitationConfig.fromRawJson(String str) => InvitationConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvitationConfig.fromJson(Map<String, dynamic> json) => InvitationConfig(
    title: json["title"],
    description: json["description"],
    referrerCreditAmount: json["referrerCreditAmount"],
    referredCreditAmount: json["referredCreditAmount"],
    isEnabled: json["isEnabled"],
    bannerImage: json["bannerImage"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "referrerCreditAmount": referrerCreditAmount,
    "referredCreditAmount": referredCreditAmount,
    "isEnabled": isEnabled,
    "bannerImage": bannerImage,
  };
}
