class AlarmResponse {
  final int userId;
  final int roomId;
  final String title;
  final String content;
  final DateTime registeredDate;

  AlarmResponse({
    required this.userId,
    required this.roomId,
    required this.title,
    required this.content,
    required this.registeredDate,
  });

  AlarmResponse.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        roomId = json['room_id'],
        title = json['title'],
        content = json['content'],
        registeredDate = DateTime(int.parse(json['registered_date']));
}
