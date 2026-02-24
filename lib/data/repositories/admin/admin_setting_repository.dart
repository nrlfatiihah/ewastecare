import 'package:firebase_auth/firebase_auth.dart';

class AdminSettingsRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> reauthenticateAdmin(String enteredPassword) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No admin is currently logged in.");
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: enteredPassword,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception("Incorrect password.");
      } else {
        throw Exception(e.message ?? "Authentication failed.");
      }
    }
  }
}
