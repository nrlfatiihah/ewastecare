import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddressEntry {
  AddressEntry({required this.id, required this.name});

  final String id;
  final String name;
}

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<String>> watchAddresses() {
    return _db.collection('Addresses').snapshots().map((snapshot) {
      final addresses = snapshot.docs
          .map((doc) {
            final data = doc.data();
            final address = (data['name'] ?? data['address'] ?? doc.id)
                .toString()
                .trim();
            return address;
          })
          .where((address) => address.isNotEmpty)
          .toSet()
          .toList();

      addresses.sort(
        (left, right) => left.toLowerCase().compareTo(right.toLowerCase()),
      );
      return addresses;
    });
  }

  Stream<List<AddressEntry>> watchAddressEntries() {
    return _db.collection('Addresses').snapshots().map((snapshot) {
      final entries = snapshot.docs
          .map((doc) {
            final data = doc.data();
            final name = (data['name'] ?? data['address'] ?? doc.id)
                .toString()
                .trim();
            return AddressEntry(id: doc.id, name: name);
          })
          .where((entry) => entry.name.isNotEmpty)
          .toList();

      entries.sort(
        (left, right) =>
            left.name.toLowerCase().compareTo(right.name.toLowerCase()),
      );
      return entries;
    });
  }

  Future<void> addAddress(String address) async {
    final normalizedAddress = address.trim();
    if (normalizedAddress.isEmpty) {
      return;
    }

    final snapshot = await _db.collection('Addresses').get();
    final alreadyExists = snapshot.docs.any((doc) {
      final data = doc.data();
      final existingAddress = (data['name'] ?? data['address'] ?? doc.id)
          .toString()
          .trim();
      return existingAddress.toLowerCase() == normalizedAddress.toLowerCase();
    });

    if (alreadyExists) {
      return;
    }

    await _db.collection('Addresses').add({
      'name': normalizedAddress,
      'searchKey': normalizedAddress.toLowerCase(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteAddress(String addressId) async {
    await _db.collection('Addresses').doc(addressId).delete();
  }
}
