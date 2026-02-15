import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSettingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getRecycleRatePassword() async {
    DocumentSnapshot doc = await _firestore
        .collection('admin_settings')
        .doc('recycle_rate_access')
        .get();

    if (doc.exists) {
      return doc['password'];
    } else {
      throw Exception('Password document not found.');
    }
  }
}
