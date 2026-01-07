class Message {
  final String id;
  final String roomId;
  final String content;
  final DateTime timeSent;
  final String userId;

  Message({
    required this.id,
    required this.roomId,
    required this.content,
    required this.timeSent,
    required this.userId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      roomId: json['roomId'],
      content: json['content'],
      timeSent: DateTime.parse(json['timestamp']),
      userId: json['senderId'],
    );
  }
}
