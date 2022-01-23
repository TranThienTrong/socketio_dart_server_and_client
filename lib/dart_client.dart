import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'chat_model.dart';

/**
  Android Emulator has huge problem with port 3000, so remember to use
    adb reverse tcp:3000 tcp:3000
 */

main() {
  late Socket socket;
  final List<ChatModel> _messagesList = [];

  try {
    socket = io("http://localhost:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.connect();

    socket.on('connect', (data) {
      debugPrint('Socket.io connected: ${socket.connected}');

      socket.emit(
          "msg",
          ChatModel(
                  id: socket.id!,
                  message: "123",
                  username: "trong",
                  sentAt: DateTime.now().toLocal().toString().substring(0, 16))
              .toJson());
    });

    socket.on('message', (data) {
      var message = ChatModel.fromJson(data);
      _messagesList.add(message);
    });

    socket.onDisconnect((_) => debugPrint('disconnect'));
  } catch (e) {
    print(e);
  }
}
