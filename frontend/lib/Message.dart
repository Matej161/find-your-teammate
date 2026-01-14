class Message {
  final String id;
  final String roomId;
  final String content;
  final DateTime timeSent;
  final String userId;
  String username;

  Message({
    required this.id,
    required this.roomId,
    required this.content,
    required this.timeSent,
    required this.userId,
    required this.username
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      roomId: json['roomId'],
      content: json['content'],
      timeSent: DateTime.parse(json['timestamp']),
      userId: json['senderId'],
      username: json["username"]
    );
  }
}
