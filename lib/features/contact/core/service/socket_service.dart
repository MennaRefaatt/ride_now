import 'package:ride_now/features/contact/core/service/socket_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/helpers/safe_print.dart';

class SocketService {
  late IO.Socket socket;

  void initSocket() {
    socket = IO.io(SocketConstants.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Listen for general events
    socket.onConnect((_) {
      safePrint('Connected to the chat server');
      socket.emit('Connected to the chat server');
    });

    socket.onDisconnect((_) {
      safePrint('Disconnected from the chat server');
      socket.emit('Disconnected from the chat server');
    });
  }

  void joinRoom() {
    socket.emit('join room');
    safePrint('Joined room:');
  }

  void sendMessage( dynamic message) {
    socket.emit('send message', message);
    safePrint('Message sent to room: $message');
  }

  void listenToRoom(String roomId, Function(dynamic) onMessageReceived) {
    socket.on('chat message', (data) {
      if (data['roomId'] == roomId) {
        onMessageReceived(data['newMessage']);
      }
    });
  }

  void dispose() {
    socket.dispose();
  }
}
