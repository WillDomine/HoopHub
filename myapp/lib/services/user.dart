import 'real_time_db.dart';
import 'auth.dart';

class UserData {
  static List<String> savedPlayers = [];

  static void init() async {
    savedPlayers = await loadSavedPlayers();
  }

  static Future<List<String>> loadSavedPlayers() async {
    Map<String, dynamic>? data =
        await RealTimeDB.read(Auth().auth.currentUser!.uid);
    if (data != null) {
      return List<String>.from(data.values);
    } else {
      return [];
    }
  }

  static Future<bool> addPlayer(String playerId) async {
    return false;
  }

  static Future<bool> removePlayer(String playerId) async {
    return false;
  }
}
