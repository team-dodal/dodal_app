class AlarmResponse {
  final int userId;
  final int roomId;
  final String title;
  final String content;
  final DateTime registeredAt;

  AlarmResponse({
    required this.userId,
    required this.roomId,
    required this.title,
    required this.content,
    required this.registeredAt,
  });

  AlarmResponse.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        roomId = json['room_id'],
        title = json['title'],
        content = json['content'],
        registeredAt = DateTime.parse(json['registered_at']);
}
