import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

class ScoreSocketController extends GetxController {
  IO.Socket? socket;
  RxBool isConnected = false.obs;
  RxString connectionStatus = 'Disconnected'.obs;
  final int maxReconnectionAttempts = 10; // Increased
  int reconnectionAttempts = 0;
  Timer? _reconnectTimer;
  Timer? _connectionTimeoutTimer;

  @override
  void onInit() {
    super.onInit();
  }

  void initializeSocket() {
    try {
      // Check if socket is already connected or connecting
      if (socket != null &&
          (socket!.connected || connectionStatus.value == 'Connecting')) {
        debugPrint(
          "🔌 Socket already connected or connecting. Skipping initialization.",
        );
        return;
      }

      final token = GetStorage().read(
        'token',
      ); // Make sure this matches your actual token key
      debugPrint("🔌 Initializing socket...");

      if (token == null) {
        debugPrint("❌ No token found!");
        return;
      }

      _disposeSocket();

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
            .setQuery({'EIO': '4', 'transport': 'websocket'})
            .setExtraHeaders({'authorization': 'Bearer $token'})
            .enableForceNew()
            .enableReconnection()
            .build(),
      );

      _setupEventListeners();
      _connectWithTimeout();
    } catch (e) {
      debugPrint('❌ Socket initialization failed: $e');
      _scheduleReconnect();
    }
  }

  void _connectWithTimeout() {
    debugPrint('🔄 Attempting to connect with timeout...');
    connectionStatus.value = 'Connecting';

    // Set connection timeout
    _connectionTimeoutTimer = Timer(Duration(seconds: 15), () {
      if (!isConnected.value) {
        debugPrint('⏰ Connection timeout reached');
        socket?.disconnect();
        _scheduleReconnect();
      }
    });

    socket?.connect();
  }

  void _setupEventListeners() {
    if (socket == null) return;

    socket!.onConnect((_) {
      _connectionTimeoutTimer?.cancel();
      isConnected.value = true;
      connectionStatus.value = 'Connected';
      reconnectionAttempts = 0;
      debugPrint('✅ Socket.IO Connected successfully!');

      _cancelReconnectTimer();
    });

    socket!.onDisconnect((_) {
      _connectionTimeoutTimer?.cancel();
      isConnected.value = false;
      connectionStatus.value = 'Disconnected';
      debugPrint('🔌 Socket.IO Disconnected');
      _scheduleReconnect();
    });

    socket!.onConnectError((data) {
      _connectionTimeoutTimer?.cancel();
      isConnected.value = false;
      connectionStatus.value = 'Connection Error';
      debugPrint('❌ Socket.IO Connect Error: $data');
      _scheduleReconnect();
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
    });

    socket!.onReconnectAttempt((attempt) {
      debugPrint('🔄 Socket.IO Reconnect attempt: $attempt');
    });

    socket!.onReconnectError((data) {
      debugPrint('❌ Socket.IO Reconnect Error: $data');
    });

    socket!.onReconnectFailed((_) {
      debugPrint('🚫 Socket.IO Reconnect Failed');
    });

    // Test event listeners
    socket!.on('connect', (_) {
      debugPrint('🎉 Connected event received');
    });
    socket!.on('new_message', (_) {
      debugPrint('🎉 new_message event received');
    });

    // Global listener for debugging unblur_request_approved
    socket!.on('unblur_request_approved', (data) {
      debugPrint(
        '🔍 GLOBAL SOCKET LISTENER: unblur_request_approved received with data: $data',
      );
    });
  }

  void _scheduleReconnect() {
    _cancelReconnectTimer();
    _connectionTimeoutTimer?.cancel();

    if (reconnectionAttempts < maxReconnectionAttempts) {
      reconnectionAttempts++;
      final delay = Duration(seconds: reconnectionAttempts);

      debugPrint(
        '⏰ Scheduling reconnect in ${delay.inSeconds}s (attempt $reconnectionAttempts/$maxReconnectionAttempts)',
      );

      _reconnectTimer = Timer(delay, () {
        if (!isConnected.value) {
          debugPrint('🔄 Executing reconnect attempt $reconnectionAttempts');
          initializeSocket();
        }
      });
    } else {
      debugPrint('🚫 Maximum reconnection attempts reached');
      connectionStatus.value = 'Connection Failed - Please restart app';
    }
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void _disposeSocket() {
    _cancelReconnectTimer();
    _connectionTimeoutTimer?.cancel();
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
      reconnect();
    }
  }

  void reconnect() {
    debugPrint('🔄 Manual reconnect triggered');
    reconnectionAttempts = 0;
    initializeSocket();
  }

  void disconnect() {
    debugPrint('🛑 Manual disconnect');
    _disposeSocket();
    connectionStatus.value = 'Disconnected';
  }

  @override
  void onClose() {
    debugPrint('🛑 Closing socket controller');
    _disposeSocket();
    super.onClose();
  }
}
