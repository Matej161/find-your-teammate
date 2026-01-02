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
      id: json['Id'],
      roomId: json['RoomId'],
      content: json['Content'],
      timeSent: DateTime.parse(json['TimeSent']),
      userId: json['UserId'],
    );
  }
}
