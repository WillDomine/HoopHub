import 'package:firebase_database/firebase_database.dart';

class RealTimeDB {
  static void write(String userId, Map<String, dynamic> data) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userId');
      await ref.set(data);
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<String, dynamic>?> read(String userId) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userId');
      DataSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> delete(String userId, String playerId) async {
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('users/$userId/$playerId');
      await ref.remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> update(String userId, Map<String, dynamic> data) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userId');
      await ref.update(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
