import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'Message.dart'; // ⬅️ TOTO NESMÍ CHYBĚT


class SignalRContracts {
  late HubConnection _connection;

  final _messageController = StreamController<Message>.broadcast();
  Stream<Message> get messages => _messageController.stream;

  Future<void> connect() async {
    _connection = HubConnectionBuilder()
        .withUrl('http://10.0.2.2:5097/chatHub')
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

  Future<void> sendMessage(String roomId, String content, String userId) async {
    await _connection.invoke(
      'SendChatMessage',
      args: [roomId, content, userId],
    );
  }

  Future<List<Message>> getChatHistory(String roomId) async {
    try {
      // I když server není async, Flutter na odpověď počkat musí
      final result = await _connection.invoke(
        'GetChatHistory', // Název tvé metody na serveru
        args: [roomId],
      );

      if (result == null) return [];

      // Přetypování z Object? na List a pak na tvoje Message objekty
      return (result as List)
          .map((m) => Message.fromJson(Map<String, dynamic>.from(m as Map)))
          .toList();
          
    } catch (e) {
      print("Chyba při načítání historie: $e");
      return [];
    }
  }

  Future<bool> canLogin(String email, String password) async {
    final result = await _connection.invoke(
        'CanLogin', 
        args: [email, password],
      );
      return result as bool;
  }

  Future<bool> createAccount(String username, String email, String password) async {
    final result = await _connection.invoke(
      'CreateAccount', 
      args: [username, email, password],
    );
    return result as bool;
  }

  Future<String> login(String email) async {
    final result = await _connection.invoke(
      'Login', 
      args: [email],
    );
    return result as String;
  }

  Future<void> dispose() async {
    await _messageController.close();
    await _connection.stop();
  }
}
