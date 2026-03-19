import 'package:get/get.dart';
import 'dart:convert';
// class PricingPlan {
//   final String name;
//   final String credits;
//   final String price;
//   final String? badge;
//   final List<String> features;
//   final bool isFeatured;
//
//   PricingPlan({
//     required this.name,
//     required this.credits,
//     required this.price,
//     this.badge,
//     required this.features,
//     this.isFeatured = false,
//   });
// }







class GetPlanListResponseModel {
  String? status;
  String? message;
  List<PricingPlan>? data;
  Pagination? pagination;

  GetPlanListResponseModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  GetPlanListResponseModel copyWith({
    String? status,
    String? message,
    List<PricingPlan>? data,
    Pagination? pagination,
  }) =>
      GetPlanListResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory GetPlanListResponseModel.fromRawJson(String str) => GetPlanListResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPlanListResponseModel.fromJson(Map<String, dynamic> json) => GetPlanListResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<PricingPlan>.from(json["data"]!.map((x) => PricingPlan.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class PricingPlan {
  String? id;
  String? name;
  String? description;
  String? price;
  String? currency;
  int? credits;
  int? matchesLimit;
  String? loungeSwitches;
  bool? isFree;
  String? billingCycle;
  String? badge;
  int? sortOrder;
  bool? isActive;
  String? createdBy;
  String? createdByIp;
  String? updatedByIp;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? updatedBy;
  String? iosPlanId;

  PricingPlan({
    this.id,
    this.name,
    this.description,
    this.price,
    this.currency,
    this.credits,
    this.matchesLimit,
    this.loungeSwitches,
    this.isFree,
    this.billingCycle,
    this.badge,
    this.sortOrder,
    this.isActive,
    this.createdBy,
    this.createdByIp,
    this.updatedByIp,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.iosPlanId,
  });

  PricingPlan copyWith({
    String? id,
    String? name,
    String? description,
    String? price,
    String? currency,
    int? credits,
    int? matchesLimit,
    String? loungeSwitches,
    bool? isFree,
    String? billingCycle,
    String? badge,
    int? sortOrder,
    bool? isActive,
    String? createdBy,
    String? createdByIp,
    String? updatedByIp,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? updatedBy,
    String? iosPlanId,
  }) =>
      PricingPlan(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        credits: credits ?? this.credits,
        matchesLimit: matchesLimit ?? this.matchesLimit,
        loungeSwitches: loungeSwitches ?? this.loungeSwitches,
        isFree: isFree ?? this.isFree,
        billingCycle: billingCycle ?? this.billingCycle,
        badge: badge ?? this.badge,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        createdBy: createdBy ?? this.createdBy,
        createdByIp: createdByIp ?? this.createdByIp,
        updatedByIp: updatedByIp ?? this.updatedByIp,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        iosPlanId: iosPlanId ?? this.iosPlanId,
      );

  factory PricingPlan.fromRawJson(String str) => PricingPlan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PricingPlan.fromJson(Map<String, dynamic> json) => PricingPlan(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    price: json["price"].toString(),
    currency: json["currency"],
    credits: json["credits"],
    matchesLimit: json["matchesLimit"],
    loungeSwitches: json["loungeSwitches"],
    isFree: json["isFree"],
    billingCycle: json["billingCycle"],
    badge: json["badge"],
    sortOrder: json["sortOrder"],
    isActive: json["isActive"],
    createdBy: json["createdBy"],
    createdByIp: json["createdByIp"],
    updatedByIp: json["updatedByIp"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    updatedBy: json["updatedBy"],
    iosPlanId: json["ios_plan_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "price": price,
    "currency": currency,
    "credits": credits,
    "matchesLimit": matchesLimit,
    "loungeSwitches": loungeSwitches,
    "isFree": isFree,
    "billingCycle": billingCycle,
    "badge": badge,
    "sortOrder": sortOrder,
    "isActive": isActive,
    "createdBy": createdBy,
    "createdByIp": createdByIp,
    "updatedByIp": updatedByIp,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "updatedBy": updatedBy,
    "ios_plan_id": iosPlanId,
  };
}

class Pagination {
  int? totalRecords;
  int? currentPage;
  int? totalPages;
  int? pageSize;

  Pagination({
    this.totalRecords,
    this.currentPage,
    this.totalPages,
    this.pageSize,
  });

  Pagination copyWith({
    int? totalRecords,
    int? currentPage,
    int? totalPages,
    int? pageSize,
  }) =>
      Pagination(
        totalRecords: totalRecords ?? this.totalRecords,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        pageSize: pageSize ?? this.pageSize,
      );

  factory Pagination.fromRawJson(String str) => Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalRecords: json["totalRecords"],
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    pageSize: json["pageSize"],
  );

  Map<String, dynamic> toJson() => {
    "totalRecords": totalRecords,
    "currentPage": currentPage,
    "totalPages": totalPages,
    "pageSize": pageSize,
  };
}


class PaginationHasMore {
  final int page;
  final int limit;
  final bool hasMore;

  const PaginationHasMore({
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  PaginationHasMore copyWith({
    int? page,
    int? limit,
    bool? hasMore,
  }) =>
      PaginationHasMore(
        page: page ?? this.page,
        limit: limit ?? this.limit,
        hasMore: hasMore ?? this.hasMore,
      );

  factory PaginationHasMore.fromRawJson(String str) =>
      PaginationHasMore.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginationHasMore.fromJson(Map<String, dynamic> json) =>
      PaginationHasMore(
        page: json["page"] as int,
        limit: json["limit"] as int,
        hasMore: json["hasMore"] as bool,
      );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "hasMore": hasMore,
  };

// Optional helper: check if there is more data to load

}


