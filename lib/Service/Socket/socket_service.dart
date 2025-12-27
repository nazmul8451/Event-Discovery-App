import 'package:gathering_app/Service/urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect(String token) {
    if (socket != null && socket!.connected) return;

    debugPrint("🔌 Connecting to socket... ${Urls.baseUrl}");
    
    socket = IO.io(Urls.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token} // Adjust based on server requirements
    });

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint('✅ Connected to socket');
    });

    socket!.onDisconnect((_) {
      debugPrint('❌ Disconnected from socket');
    });

    socket!.onConnectError((data) {
      debugPrint('⚠️ Connection Error: $data');
    });

    socket!.onError((data) {
      debugPrint('🚨 Error: $data');
    });
  }

  void emit(String event, dynamic data) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, data);
    } else {
      debugPrint('⚠️ Socket not connected. Cannot emit $event');
    }
  }

  void on(String event, Function(dynamic) handler) {
    socket?.on(event, handler);
  }

  void off(String event) {
    socket?.off(event);
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
