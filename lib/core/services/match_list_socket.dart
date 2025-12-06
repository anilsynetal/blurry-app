
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

class MatchListSocket extends GetxController {
  IO.Socket? socket;
  RxBool isConnected = false.obs;
  RxString connectionStatus = 'Disconnected'.obs;
  final int maxReconnectionAttempts = 10; // Increased
  int reconnectionAttempts = 0;

  @override
  void onInit() {
    super.onInit();
    initializeSocket();
  }

  void initializeSocket() {
    try {
      // Check if socket is already initialized
      if (socket != null) {
        debugPrint("🔌 MatchListSocket already initialized.");
        if (!socket!.connected) {
           socket!.connect();
        }
        return;
      }

      final token = GetStorage().read('token'); // Make sure this matches your actual token key
      debugPrint("🔌 Initializing socket...");

      if (token == null) {
        debugPrint("❌ No token found!");
        return;
      }

      // Enhanced configuration
      socket = IO.io(
        'https://api.soulfirst.io',
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling']) // Try both transports
            .setTimeout(30000) // 30 seconds timeout
            .setReconnectionDelay(2000)
            .enableAutoConnect()
            .setReconnectionDelayMax(10000)
            .setReconnectionAttempts(maxReconnectionAttempts)
            .setPath('/socket.io/')
            .setQuery({
          'EIO': '4',
          'transport': 'websocket',
        })
            .setExtraHeaders({
          'authorization': 'Bearer $token',
        })
            .enableForceNew()
            .enableReconnection()
            .build(),
      );

      _setupEventListeners();
      socket!.connect();

    } catch (e) {
      debugPrint('❌ Socket initialization failed: $e');
    }
  }

  void _setupEventListeners() {
    if (socket == null) return;

    socket!.onConnect((_) {
      isConnected.value = true;
      connectionStatus.value = 'Connected';
      reconnectionAttempts = 0;
      debugPrint('✅ Socket.IO Connected successfully!');
    });

    socket!.onDisconnect((_) {
      isConnected.value = false;
      connectionStatus.value = 'Disconnected';
      debugPrint('🔌 Socket.IO Disconnected');
    });

    socket!.onConnectError((data) {
      isConnected.value = false;
      connectionStatus.value = 'Connection Error';
      debugPrint('❌ Socket.IO Connect Error: $data');
    });

    socket!.onError((data) {
      debugPrint('❌ Socket.IO General Error: $data');
    });

    socket!.onConnecting((_) {
      connectionStatus.value = 'Connecting';
      debugPrint('🔄 Socket.IO Connecting...');
    });

    socket!.onReconnect((_) {
      debugPrint('🔄 Socket.IO Reconnected');
      isConnected.value = true;
      connectionStatus.value = 'Connected';
    });

    socket!.onReconnectAttempt((attempt) {
      debugPrint('🔄 Socket.IO Reconnect attempt: $attempt');
      connectionStatus.value = 'Reconnecting...';
    });

    socket!.onReconnectError((data) {
      debugPrint('❌ Socket.IO Reconnect Error: $data');
    });

    socket!.onReconnectFailed((_) {
      debugPrint('🚫 Socket.IO Reconnect Failed');
      connectionStatus.value = 'Connection Failed';
    });

    // Test event listeners
    socket!.on('connect', (_) {
      debugPrint('🎉 Connected event received');
    });
  }

  void _disposeSocket() {
    if (socket != null) {
      debugPrint('🧹 Disposing existing socket');
      socket!.disconnect();
      socket!.clearListeners();
      socket!.destroy();
      socket = null;
    }
    isConnected.value = false;
  }

  // Test connection
  void testConnection() {
    if (socket != null && socket!.connected) {
      debugPrint('✅ Socket is connected');
      socket!.emit('test', {'message': 'Hello from Flutter'});
    } else {
      debugPrint('❌ Socket is not connected');
      socket?.connect();
    }
  }

  void reconnect() {
    debugPrint('🔄 Manual reconnect triggered');
    if (socket != null) {
      socket!.connect();
    } else {
      initializeSocket();
    }
  }

  void disconnect() {
    debugPrint('🛑 Manual disconnect');
    socket?.disconnect();
    connectionStatus.value = 'Disconnected';
  }

  @override
  void onClose() {
    debugPrint('🛑 Closing socket controller');
    _disposeSocket();
    super.onClose();
  }
}