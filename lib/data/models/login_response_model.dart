
import 'dart:convert';

class LoginResponseModel {
  String? status;
  String? message;
  LoginResponseData? data;

  LoginResponseModel({
    this.status,
    this.message,
    this.data,
  });

  LoginResponseModel copyWith({
    String? status,
    String? message,
    LoginResponseData? data,
  }) =>
      LoginResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LoginResponseModel.fromRawJson(String str) => LoginResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : LoginResponseData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class LoginResponseData {
  String? token;
  UserData? user;

  LoginResponseData({
    this.token,
    this.user,
  });

  LoginResponseData copyWith({
    String? token,
    UserData? user,
  }) =>
      LoginResponseData(
        token: token ?? this.token,
        user: user ?? this.user,
      );

  factory LoginResponseData.fromRawJson(String str) => LoginResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseData.fromJson(Map<String, dynamic> json) => LoginResponseData(
    token: json["token"],
    user: json["user"] == null ? null : UserData.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
  };
}

class UserData {
  dynamic platform;
  String? id;
  String? name;
  String? email;
  dynamic avatar;
  dynamic address;
  dynamic city;
  dynamic state;
  dynamic country;
  dynamic pincode;
  dynamic dob;
  dynamic age;
  dynamic height;
  String? heightUnit;
  dynamic punchLine;
  dynamic gender;
  dynamic bio;
  String? role;
  String? signupProvider;
  dynamic mobileOtp;
  dynamic mobileOtpExpiresAt;
  String? deviceToken;
  bool? isMobileVerified;
  bool? isEmailVerified;
  bool? isTnCApproved;
  bool? isPasswordChanged;
  int? walletCredit;
  bool? isActive;
  bool? isDeleted;
  DateTime? registrationDate;
  dynamic createdByIp;
  dynamic updatedByIp;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastLogin;
  DateTime? lastLogout;
  DeviceInfo? deviceInfo;

  UserData({
    this.platform,
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.dob,
    this.age,
    this.height,
    this.signupProvider,
    this.heightUnit,
    this.punchLine,
    this.gender,
    this.bio,
    this.role,
    this.mobileOtp,
    this.mobileOtpExpiresAt,
    this.deviceToken,
    this.isMobileVerified,
    this.isEmailVerified,
    this.isTnCApproved,
    this.isPasswordChanged,
    this.walletCredit,
    this.isActive,
    this.isDeleted,
    this.registrationDate,
    this.createdByIp,
    this.updatedByIp,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.lastLogout,
    this.deviceInfo,
  });

  UserData copyWith({
    dynamic platform,
    String? id,
    String? name,
    String? email,
    dynamic avatar,
    dynamic address,
    dynamic city,
    dynamic state,
    dynamic country,
    dynamic pincode,
    dynamic dob,
    dynamic age,
    dynamic height,
    String? heightUnit,
    dynamic punchLine,
    dynamic gender,
    dynamic bio,
    String? role,
    String? signupProvider,
    dynamic mobileOtp,
    dynamic mobileOtpExpiresAt,
    String? deviceToken,
    bool? isMobileVerified,
    bool? isEmailVerified,
    bool? isTnCApproved,
    bool? isPasswordChanged,
    int? walletCredit,
    bool? isActive,
    bool? isDeleted,
    DateTime? registrationDate,
    dynamic createdByIp,
    dynamic updatedByIp,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    DateTime? lastLogout,
    DeviceInfo? deviceInfo,
  }) =>
      UserData(
        platform: platform ?? this.platform,
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pincode: pincode ?? this.pincode,
        dob: dob ?? this.dob,
        age: age ?? this.age,
        height: height ?? this.height,
        heightUnit: heightUnit ?? this.heightUnit,
        punchLine: punchLine ?? this.punchLine,
        gender: gender ?? this.gender,
        bio: bio ?? this.bio,
        role: role ?? this.role,
        signupProvider: signupProvider ?? this.signupProvider,
        mobileOtp: mobileOtp ?? this.mobileOtp,
        mobileOtpExpiresAt: mobileOtpExpiresAt ?? this.mobileOtpExpiresAt,
        deviceToken: deviceToken ?? this.deviceToken,
        isMobileVerified: isMobileVerified ?? this.isMobileVerified,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        isTnCApproved: isTnCApproved ?? this.isTnCApproved,
        isPasswordChanged: isPasswordChanged ?? this.isPasswordChanged,
        walletCredit: walletCredit ?? this.walletCredit,
        isActive: isActive ?? this.isActive,
        isDeleted: isDeleted ?? this.isDeleted,
        registrationDate: registrationDate ?? this.registrationDate,
        createdByIp: createdByIp ?? this.createdByIp,
        updatedByIp: updatedByIp ?? this.updatedByIp,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastLogin: lastLogin ?? this.lastLogin,
        lastLogout: lastLogout ?? this.lastLogout,
        deviceInfo: deviceInfo ?? this.deviceInfo,
      );

  factory UserData.fromRawJson(String str) => UserData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    platform: json["platform"],
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    avatar: json["avatar"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    pincode: json["pincode"],
    dob: json["dob"],
    age: json["age"],
    height: json["height"],
    heightUnit: json["heightUnit"],
    punchLine: json["punchLine"],
    gender: json["gender"],
    bio: json["bio"],
    role: json["role"],
    mobileOtp: json["mobileOtp"],
    mobileOtpExpiresAt: json["mobileOtpExpiresAt"],
    deviceToken: json["deviceToken"],
    isMobileVerified: json["isMobileVerified"],
    isEmailVerified: json["isEmailVerified"],
    isTnCApproved: json["isTnCApproved"],
    isPasswordChanged: json["isPasswordChanged"],
    walletCredit: json["walletCredit"],
    isActive: json["isActive"],
    signupProvider: json["signupProvider"],
    isDeleted: json["isDeleted"],
    registrationDate: json["registrationDate"] == null ? null : DateTime.parse(json["registrationDate"]),
    createdByIp: json["createdByIp"],
    updatedByIp: json["updatedByIp"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    lastLogin: json["lastLogin"] == null ? null : DateTime.parse(json["lastLogin"]),
    lastLogout: json["lastLogout"] == null ? null : DateTime.parse(json["lastLogout"]),
    deviceInfo: json["deviceInfo"] == null ? null : DeviceInfo.fromJson(json["deviceInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "platform": platform,
    "_id": id,
    "name": name,
    "email": email,
    "avatar": avatar,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "pincode": pincode,
    "dob": dob,
    "age": age,
    "height": height,
    "heightUnit": heightUnit,
    "punchLine": punchLine,
    "gender": gender,
    "bio": bio,
    "role": role,
    "mobileOtp": mobileOtp,
    "mobileOtpExpiresAt": mobileOtpExpiresAt,
    "deviceToken": deviceToken,
    "isMobileVerified": isMobileVerified,
    "isEmailVerified": isEmailVerified,
    "isTnCApproved": isTnCApproved,
    "isPasswordChanged": isPasswordChanged,
    "walletCredit": walletCredit,
    "signupProvider": signupProvider,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "registrationDate": registrationDate?.toIso8601String(),
    "createdByIp": createdByIp,
    "updatedByIp": updatedByIp,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "lastLogin": lastLogin?.toIso8601String(),
    "lastLogout": lastLogout?.toIso8601String(),
    "deviceInfo": deviceInfo?.toJson(),
  };
}

class DeviceInfo {
  dynamic appVersion;
  dynamic userAgent;

  DeviceInfo({
    this.appVersion,
    this.userAgent,
  });

  DeviceInfo copyWith({
    dynamic appVersion,
    dynamic userAgent,
  }) =>
      DeviceInfo(
        appVersion: appVersion ?? this.appVersion,
        userAgent: userAgent ?? this.userAgent,
      );

  factory DeviceInfo.fromRawJson(String str) => DeviceInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
    appVersion: json["appVersion"],
    userAgent: json["userAgent"],
  );

  Map<String, dynamic> toJson() => {
    "appVersion": appVersion,
    "userAgent": userAgent,
  };
}
