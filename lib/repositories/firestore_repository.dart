import 'package:cloud_firestore/cloud_firestore.dart';

final user = <String, dynamic>{
  "first": "Ada",
  "last": "Lovelace",
  "born": 1815
};

class FireStoreRepository {
  static final db = FirebaseFirestore.instance;

  static Future<bool> reportUser({
    required int userId,
    required String userName,
    required String reason,
    String? detailReason,
    int? targetRoomId,
    int? targetUserId,
  }) async {
    try {
      await db.collection("report").add({
        "userId": userId,
        "userName": userName,
        "reason": reason,
        "detailReason": detailReason,
        "targetRoomId": targetRoomId,
        "targetUserId": targetUserId,
      });
      return true;
    } catch (err) {
      return false;
    }
  }
}
