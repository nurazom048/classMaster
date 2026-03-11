// ignore_for_file: avoid_print, library_prefixes, file_names, unused_element

import 'package:classmate/core/local%20data/local_data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? _socket;

  static IO.Socket get socket {
    if (_socket == null) {
      throw Exception("Socket not initialized. Call initializeSocket() first.");
    }
    return _socket!;
  }

  static Future<void> initializeSocket() async {
    try {
      // Fetch headers (Bearer token + refresh token)
      final headers = await LocalData.getHeader();

      _socket = IO.io(
        'http://10.0.2.2:4000', // Replace with your server URL
        IO.OptionBuilder()
            .setTransports(['websocket']) // Force WebSocket
            .enableAutoConnect() // Reconnect if disconnected
            .setExtraHeaders(headers) // Attach auth headers
            .build(),
      );

      // Connection listeners
      _socket!.onConnect((_) => print('✅ Connected to Socket.IO server'));
      _socket!.onDisconnect((_) => print('❌ Disconnected from server'));
      _socket!.onError((error) => print('⚠️ Socket error: $error'));
    } catch (e) {
      print('Failed to initialize socket: $e');
      rethrow;
    }
  }

  // Join a room (matches server event `join:routine`)
  static void joinRoom(String routineID) {
    if (_socket == null) throw Exception("Socket not initialized.");
    _socket!.emit('join:routine', routineID);
  }

  // Leave a room (matches server event `leave:routine`)
  static void leaveRoom(String routineID) {
    _socket?.emit('leave:routine', routineID);
  }

  // Listen for room events (e.g., new summaries)
  static void listenToRoomEvents({
    Function(dynamic)? onSummaryCreated,
    Function(dynamic)? onRoomJoined,
  }) {
    if (onSummaryCreated != null) {
      _socket?.on('summary:created', onSummaryCreated);
    }
    if (onRoomJoined != null) {
      _socket?.on('room:joined', onRoomJoined);
    }
  }

  // Disconnect socket
  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
