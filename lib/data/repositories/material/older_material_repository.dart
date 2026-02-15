import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/features/ecobako_point/model/rate_model.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OlderMaterialRepository extends GetxController {
  static OlderMaterialRepository get instance => Get.find();

  // Firestore instance for database interactions.
  final _db = FirebaseFirestore.instance;

  Future<void> saveMaterialRecord(OldMaterialModel materials) async {
    try {
      await _db
          .collection("Materials")
          .doc(materials.id)
          .set(materials.toJson());
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> updateMaterialRecord(OldMaterialModel material) async {
    try {
      await _db.collection("Materials").doc(material.id).update({
        'value': material.value,
      });
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<bool> isIdUnique(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _db
          .collection('Materials')
          .doc(id)
          .get();
      return !docSnapshot.exists;
    } catch (e) {
      return false; // Return false to be safe if there's an error
    }
  }

  Future<List<OldMaterialModel>> getMaterialsByType(String type) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('Materials')
          .where('type', isEqualTo: type)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => OldMaterialModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
    } catch (e) {
      print('Error fetching materials: $e');
      return [];
    }
  }

  Future<void> saveTransaction(double totalPoints, String userID) async {
    try {
      await _db.collection('Transactions').add({
        'totalPoints': totalPoints,
        'transactionDate': FieldValue.serverTimestamp(),
        'description': 'Recycling points allocation',
        'transactionType': 'Allocation',
        'userID': userID,
      });
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }
}
