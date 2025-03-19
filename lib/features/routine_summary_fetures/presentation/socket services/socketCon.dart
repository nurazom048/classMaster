// ignore_for_file: avoid_print, library_prefixes, file_names, unused_element

import 'package:classmate/core/local%20data/local_data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? _socket;

  // Getter for the socket instance
  static IO.Socket get socket {
    if (_socket == null) {
      throw Exception(
          "Socket is not initialized. Call initializeSocket first.");
    }
    return _socket!;
  }

  // Asynchronous initialization of the socket
  static Future<void> initializeSocket() async {
    final headers = await LocalData.getHeader(); // Fetch headers asynchronously

    _socket = IO.io(
      'http://10.0.2.2:4000',
      IO.OptionBuilder()
          .setTransports(['websocket']) // Specify transport
          .enableAutoConnect() // Enable auto-connect
          .setAuth({'token': ''}) // Add token if needed
          .setExtraHeaders(headers) // Set extra headers
          .build(),
    );

    // Listen for connection
    _socket!.onConnect((_) {
      print('Connected to server');
    });
    void listenChat() {
      // Listen to 'chat message' events
    }

    // Listen for disconnection
    _socket!.onDisconnect((_) {
      print('Disconnected from server');
    });
  }

  // Join a room
  static void joinRoom(String room) {
    if (_socket == null) {
      throw Exception(
          "Socket is not initialized. Call initializeSocket first.");
    }
    _socket!.emit('join room', room);
    print('Joined room: $room');
  }

  // Send a chat message
  static void sendMessage({
    required String room,
  }) {
    if (_socket == null) {
      throw Exception(
          "Socket is not initialized. Call initializeSocket first.");
    }
    _socket!.emit('chat message', {
      "message": 'this is new message',
      "room": room,
    });
    print('Message sent to room $room');
  }

  // Disconnect the socket
  static void disconnect() {
    _socket?.disconnect();
  }
}
