// use and checked
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdminDashboardRepository extends GetxController {
  static AdminDashboardRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  Future<void> addAdminDashboardData(
    String userId,
    double pp,
    double pet,
    double hdpe,
    int totalEcoPoints,
  ) async {
    final userDashboardRef = _db.collection('AdminDashboard');
    final String totalPlastic = (pp + pet + hdpe).toStringAsFixed(2);
    final String typePP = pp.toStringAsFixed(2);
    final String typePET = pet.toStringAsFixed(2);
    final String typeHDPE = hdpe.toStringAsFixed(2);

    try {
      await userDashboardRef.add({
        'TypePP': double.parse(typePP),
        'TypePET': double.parse(typePET),
        'TypeHDPE': double.parse(typeHDPE),
        'TotalEcoPoints': totalEcoPoints,
        'TotalAllPlastic': double.parse(totalPlastic),
        'UserID': userId,
        "date": Timestamp.now(),
      });
    } catch (e) {
      throw "Error adding data to AdminDashboardDatabase: $e";
    }
  }

  Future<List<Map<String, dynamic>>> getAdminDashboardData() async {
    try {
      // Fetch all documents in the AdminDashboard collection
      final querySnapshot = await _db.collection("MainAdminDashboard").get();

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

  Future<List<Map<String, dynamic>>> getAdminDashboardDataByDateFilter([
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
      }
      // Query documents where the date field is between startDate and endDate

      final querySnapshot = await _db
          .collection("AdminDashboard")
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

  Future<Map<String, int>> fetchGenderStatistics() async {
    try {
      // Fetch all documents from the 'Users' collection
      QuerySnapshot snapshot = await _db.collection('users').get();

      // Initialize counters for male and female users
      int maleCount = 0;
      int femaleCount = 0;

      // Iterate over each document in the snapshot
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
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
