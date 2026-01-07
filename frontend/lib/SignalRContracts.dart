import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'Message.dart'; // ⬅️ TOTO NESMÍ CHYBĚT


class SignalRContracts {
  late HubConnection _connection;

  final _messageController = StreamController<Message>.broadcast();
  Stream<Message> get messages => _messageController.stream;

  Future<void> connect() async {
    _connection = HubConnectionBuilder()
        .withUrl('https://YOUR_API_URL/chatHub')
        .build();

    _registerHandlers();
    await _connection.start();
  }

  void _registerHandlers() {
    _connection.on('ReceiveChatMessage', (args) {
  if (args == null || args.isEmpty) return;

  final data = Map<String, dynamic>.from(args[0] as Map);

  final message = Message.fromJson(data);

  _messageController.add(message);
});


    _connection.on('ReceiveEditMessage', (args) {
      // TODO
    });

    _connection.on('ReceiveDeleteMessage', (args) {
      // TODO
    });
  }

  Future<void> joinRoom(String roomName) async {
    await _connection.invoke('JoinRoom', args: [roomName]);
  }

  Future<void> leaveRoom(String roomName) async {
    await _connection.invoke('LeaveRoom', args: [roomName]);
  }

  Future<void> sendMessage(String roomName, String content) async {
    await _connection.invoke(
      'SendChatMessage',
      args: [roomName, content],
    );
  }

  Future<void> dispose() async {
    await _messageController.close();
    await _connection.stop();
  }
}
