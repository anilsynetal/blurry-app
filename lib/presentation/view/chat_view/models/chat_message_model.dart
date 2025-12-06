import 'dart:convert';

import '../../plan/model/plan_model.dart';

class ChatDetailsResponseModel {
  String? status;
  String? message;
  Data? data;

  ChatDetailsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  ChatDetailsResponseModel copyWith({
    String? status,
    String? message,
    Data? data,
  }) =>
      ChatDetailsResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ChatDetailsResponseModel.fromRawJson(String str) => ChatDetailsResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatDetailsResponseModel.fromJson(Map<String, dynamic> json) => ChatDetailsResponseModel(
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
  Chat? chat;
  PaginationHasMore? pagination;
  ReadStatus? readStatus;

  Data({
    this.chat,
    this.pagination,
    this.readStatus,
  });

  Data copyWith({
    Chat? chat,
    PaginationHasMore? pagination,
    ReadStatus? readStatus,
  }) =>
      Data(
        chat: chat ?? this.chat,
        pagination: pagination ?? this.pagination,
        readStatus: readStatus ?? this.readStatus,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    chat: json["chat"] == null ? null : Chat.fromJson(json["chat"]),
    pagination: json["pagination"] == null ? null : PaginationHasMore.fromJson(json["pagination"]),
    readStatus: json["readStatus"] == null ? null : ReadStatus.fromJson(json["readStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "chat": chat?.toJson(),
    "pagination": pagination?.toJson(),
    "readStatus": readStatus?.toJson(),
  };
}

class Chat {
  String? chatId;
  List<OtherUser>? participants;
  OtherUser? otherUser;
  List<ChatMessage>? messages;
  int? unreadCount;
  bool? isBlocked;
  CurrentlyTyping? currentlyTyping;
  Match? match;
  DateTime? createdAt;
  DateTime? updatedAt;

  Chat({
    this.chatId,
    this.participants,
    this.otherUser,
    this.messages,
    this.unreadCount,
    this.isBlocked,
    this.currentlyTyping,
    this.match,
    this.createdAt,
    this.updatedAt,
  });

  Chat copyWith({
    String? chatId,
    List<OtherUser>? participants,
    OtherUser? otherUser,
    List<ChatMessage>? messages,
    int? unreadCount,
    bool? isBlocked,
    CurrentlyTyping? currentlyTyping,
    Match? match,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Chat(
        chatId: chatId ?? this.chatId,
        participants: participants ?? this.participants,
        otherUser: otherUser ?? this.otherUser,
        messages: messages ?? this.messages,
        unreadCount: unreadCount ?? this.unreadCount,
        isBlocked: isBlocked ?? this.isBlocked,
        currentlyTyping: currentlyTyping ?? this.currentlyTyping,
        match: match ?? this.match,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Chat.fromRawJson(String str) => Chat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    chatId: json["chatId"],
    participants: json["participants"] == null ? [] : List<OtherUser>.from(json["participants"]!.map((x) => OtherUser.fromJson(x))),
    otherUser: json["otherUser"] == null ? null : OtherUser.fromJson(json["otherUser"]),
    messages: json["messages"] == null ? [] : List<ChatMessage>.from(json["messages"]!.map((x) => ChatMessage.fromJson(x))),
    unreadCount: json["unreadCount"],
    isBlocked: json["isBlocked"],
    currentlyTyping: json["currentlyTyping"] == null ? null : CurrentlyTyping.fromJson(json["currentlyTyping"]),
    match: json["match"] == null ? null : Match.fromJson(json["match"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "chatId": chatId,
    "participants": participants == null ? [] : List<dynamic>.from(participants!.map((x) => x.toJson())),
    "otherUser": otherUser?.toJson(),
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
    "unreadCount": unreadCount,
    "isBlocked": isBlocked,
    "currentlyTyping": currentlyTyping?.toJson(),
    "match": match?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class CurrentlyTyping {
  dynamic user;
  dynamic startedAt;

  CurrentlyTyping({
    this.user,
    this.startedAt,
  });

  CurrentlyTyping copyWith({
    dynamic user,
    dynamic startedAt,
  }) =>
      CurrentlyTyping(
        user: user ?? this.user,
        startedAt: startedAt ?? this.startedAt,
      );

  factory CurrentlyTyping.fromRawJson(String str) => CurrentlyTyping.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentlyTyping.fromJson(Map<String, dynamic> json) => CurrentlyTyping(
    user: json["user"],
    startedAt: json["startedAt"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "startedAt": startedAt,
  };
}

class Match {
  String? id;
  bool? isMatched;
  DateTime? matchedAt;

  Match({
    this.id,
    this.isMatched,
    this.matchedAt,
  });

  Match copyWith({
    String? id,
    bool? isMatched,
    DateTime? matchedAt,
  }) =>
      Match(
        id: id ?? this.id,
        isMatched: isMatched ?? this.isMatched,
        matchedAt: matchedAt ?? this.matchedAt,
      );

  factory Match.fromRawJson(String str) => Match.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    id: json["_id"],
    isMatched: json["isMatched"],
    matchedAt: json["matchedAt"] == null ? null : DateTime.parse(json["matchedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isMatched": isMatched,
    "matchedAt": matchedAt?.toIso8601String(),
  };
}

class ChatMessage {
  String? sender;
  String? content;
  String? messageType;
  DateTime? timestamp;
  bool? isRead;
  dynamic readAt;
  String? id;
  String? localPath;
  int?voiceDuration;
  String?voiceUrl;

  ChatMessage({
    this.sender,
    this.content,
    this.messageType,
    this.timestamp,
    this.isRead,
    this.readAt,
    this.id,
    this.localPath,
    this.voiceUrl,
    this.voiceDuration

  });

  ChatMessage copyWith({
    String? sender,
    String? content,
    String? messageType,
    DateTime? timestamp,
    bool? isRead,
    dynamic readAt,
    String? id,
    String? localPath,
    int?voiceDuration,
    String?voiceUrl
  }) =>
      ChatMessage(
        sender: sender ?? this.sender,
        content: content ?? this.content,
        messageType: messageType ?? this.messageType,
        timestamp: timestamp ?? this.timestamp,
        isRead: isRead ?? this.isRead,
        readAt: readAt ?? this.readAt,
        id: id ?? this.id,
        localPath: localPath ?? this.localPath,
        voiceUrl: voiceUrl ?? this.voiceUrl,
        voiceDuration: voiceDuration ?? this.voiceDuration,
      );

  factory ChatMessage.fromRawJson(String str) => ChatMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    sender: json["sender"],
    content: json["content"],
    messageType: json["messageType"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    isRead: json["isRead"],
    readAt: json["readAt"],
    id: json["_id"],
    localPath: json["localPath"],
    voiceDuration: json["voiceDuration"],
    voiceUrl: json["voiceUrl"],
  );

  Map<String, dynamic> toJson() => {
    "sender": sender,
    "content": content,
    "messageType": messageType,
    "timestamp": timestamp?.toIso8601String(),
    "isRead": isRead,
    "readAt": readAt,
    "_id": id,
    "localPath": localPath,
    "voiceUrl":voiceUrl,
    "voiceDuration":voiceDuration
  };
}

class OtherUser {
  String? id;
  String? name;
  String? avatar;
  bool? isOnline;
  DateTime? lastActive;

  OtherUser({
    this.id,
    this.name,
    this.avatar,
    this.isOnline,
    this.lastActive,
  });

  OtherUser copyWith({
    String? id,
    String? name,
    String? avatar,
    bool? isOnline,
    DateTime? lastActive,
  }) =>
      OtherUser(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        isOnline: isOnline ?? this.isOnline,
        lastActive: lastActive ?? this.lastActive,
      );

  factory OtherUser.fromRawJson(String str) => OtherUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
    id: json["_id"],
    name: json["name"],
    avatar: json["avatar"],
    isOnline: json["isOnline"],
    lastActive: json["lastActive"] == null ? null : DateTime.parse(json["lastActive"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "avatar": avatar,
    "isOnline": isOnline,
    "lastActive": lastActive?.toIso8601String(),
  };
}



class ReadStatus {
  int? unreadCount;
  int? readCount;
  bool? markedAsRead;

  ReadStatus({
    this.unreadCount,
    this.readCount,
    this.markedAsRead,
  });

  ReadStatus copyWith({
    int? unreadCount,
    int? readCount,
    bool? markedAsRead,
  }) =>
      ReadStatus(
        unreadCount: unreadCount ?? this.unreadCount,
        readCount: readCount ?? this.readCount,
        markedAsRead: markedAsRead ?? this.markedAsRead,
      );

  factory ReadStatus.fromRawJson(String str) => ReadStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReadStatus.fromJson(Map<String, dynamic> json) => ReadStatus(
    unreadCount: json["unreadCount"],
    readCount: json["readCount"],
    markedAsRead: json["markedAsRead"],
  );

  Map<String, dynamic> toJson() => {
    "unreadCount": unreadCount,
    "readCount": readCount,
    "markedAsRead": markedAsRead,
  };
}




// class ChatMessage {
//   final String id;
//   final String senderId;
//   final String senderName;
//   final String content;
//   final DateTime timestamp;
//   final bool isCurrentUser;
//   final String? senderAvatar;
//
//   ChatMessage({
//     required this.id,
//     required this.senderId,
//     required this.senderName,
//     required this.content,
//     required this.timestamp,
//     required this.isCurrentUser,
//     this.senderAvatar,
//   });
//
//   factory ChatMessage.fromJson(Map<String, dynamic> json) {
//     return ChatMessage(
//       id: json['id'] as String,
//       senderId: json['senderId'] as String,
//       senderName: json['senderName'] as String,
//       content: json['content'] as String,
//       timestamp: DateTime.parse(json['timestamp'] as String),
//       isCurrentUser: json['isCurrentUser'] as bool,
//       senderAvatar: json['senderAvatar'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'senderId': senderId,
//       'senderName': senderName,
//       'content': content,
//       'timestamp': timestamp.toIso8601String(),
//       'isCurrentUser': isCurrentUser,
//       'senderAvatar': senderAvatar,
//     };
//   }
// }


