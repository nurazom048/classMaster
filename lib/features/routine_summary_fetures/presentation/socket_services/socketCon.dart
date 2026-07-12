// ignore_for_file: avoid_print, library_prefixes, file_names, unused_element

import 'package:classmate/core/constant/constant.dart';
import 'package:classmate/core/local_data/local_data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? _socket;

  static IO.Socket get socket {
    if (_socket == null) {
      throw Exception("Socket not initialized. Call initializeSocket() first.");
    }
    return _socket!;
  }

  static bool get isConnected => _socket != null && _socket!.connected;

  static Future<void> initializeSocket() async {
    try {
      if (_socket != null) {
        print('⚡ Socket already initialized. Reusing connection.');
        return;
      }

      // Fetch headers (Bearer token + refresh token)
      final headers = await LocalData.getHeader();

      // Extract authorization token from headers
      final authHeader = headers['Authorization'] ?? headers['authorization'];
      
      String? cleanToken;
      if (authHeader != null) {
        if (authHeader.startsWith('Bearer ')) {
          cleanToken = authHeader.substring(7);
        } else {
          cleanToken = authHeader.split(' ').last;
        }
      }

      print('⚡ Connecting to Socket Server at: ${Const.BASE_URl}');

      _socket = IO.io(
        Const.BASE_URl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // Force WebSocket transport
            .enableAutoConnect() // Reconnect if disconnected
            .setAuth({'token': cleanToken}) // Set standard Socket.io auth payload (Web-compatible)
            .setQuery({'token': cleanToken}) // Fallback query param (Web-compatible)
            .setExtraHeaders({
              if (authHeader != null) 'authorization': authHeader,
            })
            .build(),
      );

      // Connection status listeners
      _socket!.onConnect((_) {
        print('✅ Connected to Socket.IO server: ${_socket?.id}');
      });

      _socket!.onDisconnect((_) {
        print('❌ Disconnected from Socket.IO server');
      });

      _socket!.onError((error) {
        print('⚠️ Socket connection error: $error');
      });

      _socket!.onConnectError((error) {
        print('⚠️ Socket connection error: $error');
      });
      
    } catch (e) {
      print('❌ Failed to initialize socket: $e');
      rethrow;
    }
  }

  // Join a room (matches server event `join room`)
  static void joinRoom(String routineID) {
    if (_socket == null) {
      print('⚠️ Socket not initialized. Cannot join room.');
      return;
    }
    print('➡️ Joining Socket room: $routineID');
    _socket!.emit('join room', routineID);
  }

  // Leave a room (matches server event `leave room`)
  static void leaveRoom(String routineID) {
    if (_socket == null) return;
    print('⬅️ Leaving Socket room: $routineID');
    _socket!.emit('leave room', routineID);
  }

  // Emit typing status
  static void sendTyping(String routineID) {
    _socket?.emit('typing', routineID);
  }

  // Emit stop typing status
  static void sendStopTyping(String routineID) {
    _socket?.emit('stop_typing', routineID);
  }

  // Emit a chat message
  static void sendMessage(String routineID, String message) {
    _socket?.emit('chat message', {
      'message': message,
      'room': routineID,
    });
  }

  // Listen for room events
  static void listenToRoomEvents({
    Function(dynamic)? onChatMessage,
    Function(dynamic)? onUserTyping,
    Function(dynamic)? onUserStopTyping,
    Function(dynamic)? onUserOnline,
    Function(dynamic)? onUserOffline,
  }) {
    if (_socket == null) return;

    if (onChatMessage != null) {
      _socket!.on('chat message', onChatMessage);
    }
    if (onUserTyping != null) {
      _socket!.on('typing', onUserTyping);
    }
    if (onUserStopTyping != null) {
      _socket!.on('stop_typing', onUserStopTyping);
    }
    if (onUserOnline != null) {
      _socket!.on('user_online', onUserOnline);
    }
    if (onUserOffline != null) {
      _socket!.on('user_offline', onUserOffline);
    }
  }

  // Remove room listeners to avoid memory leaks/duplicate events
  static void removeListeners() {
    _socket?.off('chat message');
    _socket?.off('typing');
    _socket?.off('stop_typing');
    _socket?.off('user_online');
    _socket?.off('user_offline');
  }

  // Disconnect socket
  static void disconnect() {
    if (_socket != null) {
      removeListeners();
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      print('🛑 Socket disconnected and cleared.');
    }
  }
}
