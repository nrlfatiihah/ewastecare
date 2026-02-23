import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/features/waste_point/model/material_model.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NewAdminDashboardRepository extends GetxController {
  static NewAdminDashboardRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<void> saveToAdminDashboard({
    required String userId,
    required Map<String, Map<String, double>> materials,
    required int totalPoints,
    required double totalWeightAllMaterials,
  }) async {
    try {
      // Create a new document in the AdminDashboard collection with a random ID
      // await _db.collection('AdminDashboardTry').add({
      await _db.collection('MainAdminDashboard').add({
        'UserID': userId,
        'date': FieldValue.serverTimestamp(),
        'materials': materials,
        'totalWastePoints': totalPoints,
        'totalWeightAllMaterials': totalWeightAllMaterials,
      });

      print('Admin dashboard updated successfully for userId: $userId');
    } catch (e) {
      print('Error saving data to admin dashboard: $e');
      rethrow;
    }
  }

  // Fetch all documents from AdminDashboardTry collection
  Future<List<Map<String, dynamic>>> fetchAllAdminDashboardData() async {
    try {
      // final querySnapshot = await _db.collection('AdminDashboardTry').get();
      final querySnapshot = await _db.collection('MainAdminDashboard').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching MainAdminDashboard data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllAdminDashboardDataByDateFilter([
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
  ]) async {
    try {
      print("Selected Start Date at fiter part: $selectedStartDate");
      print("Selected End Date at filter part: $selectedEndDate");
      // make sure end date end with 23:59:59
      if (selectedEndDate != null) {
        selectedEndDate = DateTime(
          selectedEndDate.year,
          selectedEndDate.month,
          selectedEndDate.day,
          23,
          59,
          59,
          999,
        );
      }
      // Query documents where the date field is between startDate and endDate

      // final querySnapshot = await _db.collection("AdminDashboardTry")
      final querySnapshot = await _db
          .collection("MainAdminDashboard")
          .where('date', isGreaterThanOrEqualTo: selectedStartDate)
          .where('date', isLessThanOrEqualTo: selectedEndDate)
          .get();

      // Extract and return data from each document
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<List<Map<String, dynamic>>> fetchMaterialWeights([
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
  ]) async {
    try {
      // make sure end date end with 23:59:59
      if (selectedEndDate != null) {
        selectedEndDate = DateTime(
          selectedEndDate.year,
          selectedEndDate.month,
          selectedEndDate.day,
          23,
          59,
          59,
          999,
        );
        // final querySnapshot = await _db.collection("AdminDashboardTry")
        final querySnapshot = await _db
            .collection("MainAdminDashboard")
            .where('date', isGreaterThanOrEqualTo: selectedStartDate)
            .where('date', isLessThanOrEqualTo: selectedEndDate)
            .get();
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      } else {
        // Fetch all data if no date is selected
        // final querySnapshot = await _db.collection('AdminDashboardTry').get();
        final querySnapshot = await _db.collection('MainAdminDashboard').get();
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      }
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<List<MaterialModel>> fetchAllMaterials(String materialType) async {
    try {
      final querySnapshot = await _db
          .collection('MaterialTypes')
          .doc(materialType)
          .collection('materials')
          .get();

      return querySnapshot.docs.map((doc) {
        return MaterialModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching materials: $e');
      return [];
    }
  }

  Future<Map<String, int>> fetchGenderStatistics() async {
    try {
      // Fetch all documents from the 'Users' collection
      QuerySnapshot snapshot = await _db.collection('Users').get();

      // Initialize counters for male and female users
      int maleCount = 0;
      int femaleCount = 0;

      // Iterate over each document in the snapshot
      for (var doc in snapshot.docs) {
        // final data = doc.data() as Map<String, dynamic>;
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data == null) continue;
        final gender = (data['Gender'] as String?)?.toLowerCase() ?? '';

        // Count the number of male and female users
        if (gender == 'male') {
          maleCount++;
        } else if (gender == 'female') {
          femaleCount++;
        }
      }

      // Return the counts as a map
      return {'maleUsers': maleCount, 'femaleUsers': femaleCount};
    } catch (e) {
      print('Error fetching gender statistics: $e');
      // Return zeros in case of an error
      return {'maleUsers': 0, 'femaleUsers': 0};
    }
  }
}
