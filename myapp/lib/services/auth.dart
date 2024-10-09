import 'package:firebase_auth/firebase_auth.dart';

// Auth Service for handling Firebase Authentication
class Auth {
  // Initialize Firebase Auth
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get the current user
  User? get currentUser => auth.currentUser;

  // Get the auth state
  Stream<User?> get authStateChanges => auth.authStateChanges();

  // Sign in with email and password
  Future<(bool, String)> signInWithEmail(String email, String password) async {
    String error = "";
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return (true, "Success");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        error = 'Invalid email or password';
      }
    }
    return (false, error);
  }
  // Sign up with email and password
  Future<(bool, String)> signUpWithEmail(String email, String password) async {
    String error = "";
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return (true, "Success");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }

    return (false, error);
  }
  // Sign out
  Future<bool> signOut() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      }
    }
    return false;
  }
  // Delete user: Currently Not Used!
  Future<bool> deleteUser() async {
    try {
      await auth.currentUser!.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
    return false;
  }
}
