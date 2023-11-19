class AlarmResponse {
  final int userId;
  final int roomId;
  final String title;
  final String content;
  final DateTime registeredAt;
  final String registerCode;

  AlarmResponse.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        roomId = json['room_id'],
        title = json['title'],
        content = json['content'],
        registeredAt = DateTime.parse(json['registered_at']),
        registerCode = json['register_code'];
}
