import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static Future<bool> signUp(String email, String password) async {
    try {
      await Supabase.instance.client.auth
          .signUp(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signIn(String email, String password) async {
    try {
      await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isSignedIn() async {
    return Supabase.instance.client.auth.currentUser != null;
  }

  static Future<void> resetPassword(String email) async {
    await Supabase.instance.client.auth.resetPasswordForEmail(email);
  }
}
