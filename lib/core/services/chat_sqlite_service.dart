// services/database_service.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../presentation/view/chat_view/models/chat_message_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chat_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        chatId TEXT,
        sender TEXT,
        content TEXT,
        messageType TEXT,
        timestamp TEXT,
        isRead INTEGER,
        readAt TEXT,
        localPath TEXT,
        voiceDuration INTEGER
      )
    ''');
  }

  Future<void> saveMessage(ChatMessage message, String chatId) async {
    final db = await database;
    await db.insert('messages', {
      'id': message.id,
      'chatId': chatId,
      'sender': message.sender,
      'content': message.content,
      'messageType': message.messageType,
      'timestamp': message.timestamp?.toUtc().toIso8601String(),
      'isRead': message.isRead == true ? 1 : 0,
      'readAt': message.readAt?.toString(),
      'localPath': message.localPath,
      'voiceDuration': message.voiceDuration,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ChatMessage>> getMessages(String chatId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) {
      return ChatMessage(
        id: maps[i]['id'],
        sender: maps[i]['sender'],
        content: maps[i]['content'],
        messageType: maps[i]['messageType'],
        timestamp: maps[i]['timestamp'] != null
            ? DateTime.parse(maps[i]['timestamp'])
            : null,
        isRead: maps[i]['isRead'] == 1,
        readAt: maps[i]['readAt'],
        localPath: maps[i]['localPath'],
      );
    });
  }

  Future<void> markMessagesAsRead(String chatId) async {
    final db = await database;
    await db.update(
      'messages',
      {'isRead': 1, 'readAt': DateTime.now().toIso8601String()},
      where: 'chatId = ? AND isRead = ?',
      whereArgs: [chatId, 0],
    );
  }

  Future<void> clearChat(String chatId) async {
    final db = await database;
    await db.delete('messages', where: 'chatId = ?', whereArgs: [chatId]);
  }
}
