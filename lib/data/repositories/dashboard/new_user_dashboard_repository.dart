import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/data/repositories/dashboard/new_admin_dashboard_repository.dart';
import 'package:ewastecare/features/dashboard/models/user_dashboard_constant.dart';
import 'package:get/get.dart';

class NewUserDashboardRepository extends GetxController {
  static NewUserDashboardRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final newAdminDashboardRepository = NewAdminDashboardRepository();

  Future<void> updateUserDashboardWithTransaction({
    required String userId,
    required Map<String, Map<String, double>> materials,
    required int totalPoints,
    required double totalPrice,
  }) async {
    try {
      // Fetch existing user data from UserDashboard using userId as the document ID
      final userDoc = await _db
          .collection('UserDashboardTry')
          .doc(userId)
          .get();

      // Initialize existing data if the document doesn't exist, otherwise use the existing document data
      Map<String, dynamic> existingData = userDoc.exists
          ? userDoc.data() as Map<String, dynamic>
          : {};

      // Initialize or fetch existing materials, total points, and total weight
      Map<String, Map<String, double>> existingMaterials =
          existingData['materials'] != null
          ? Map<String, Map<String, double>>.from(
              existingData['materials'].map(
                (key, value) => MapEntry(key, Map<String, double>.from(value)),
              ),
            )
          : {};

      double existingTotalPoints = existingData['totalWastePoints'] != null
          ? existingData['totalWastePoints'] as double
          : 0.0;

      // Update the existing materials with new values and ensure they are formatted to two decimal places
      materials.forEach((materialType, subMaterials) {
        if (!existingMaterials.containsKey(materialType)) {
          existingMaterials[materialType] = {};
        }

        subMaterials.forEach((subMaterial, weight) {
          // Update material weight by adding the new weight from the transaction
          double updatedWeight =
              (existingMaterials[materialType]![subMaterial] ?? 0.0) + weight;

          // Ensure the weight is formatted to two decimal points
          existingMaterials[materialType]![subMaterial] = double.parse(
            updatedWeight.toStringAsFixed(2),
          );
        });
      });

      // Calculate the current weight of all materials (i.e., from this transaction only)
      double currentTotalWeight = materials.values
          .expand((subMaterials) => subMaterials.values)
          .reduce((a, b) => a + b);

      currentTotalWeight = double.parse(
        currentTotalWeight.toStringAsFixed(2),
      ); // Format to two decimal points

      // Calculate new total weight of all materials and format to two decimal points
      double newTotalWeight = existingMaterials.values
          .expand((subMaterials) => subMaterials.values)
          .reduce((a, b) => a + b);

      newTotalWeight = double.parse(
        newTotalWeight.toStringAsFixed(2),
      ); // Format to two decimal points

      // Update total points by adding the new transaction points
      double updatedTotalPoints = existingTotalPoints + totalPoints;

      // Determine the TierLevel based on the new total weight using TierCriteria
      String tierLevel = determineTierLevel(newTotalWeight);

      await newAdminDashboardRepository.saveToAdminDashboard(
        userId: userId,
        materials: materials,
        totalPoints: totalPoints,
        totalWeightAllMaterials: currentTotalWeight,
      );

      // Update the database with aggregated data, including TierLevel
      await _db.collection('UserDashboardTry').doc(userId).set(
        {
          'materials': existingMaterials, // Updated material weights
          'totalWastePoints': updatedTotalPoints, // Updated points
          'totalWeightAllMaterials':
              newTotalWeight, // Updated total weight formatted to two decimal points
          'TierLevel': tierLevel, // Updated tier level
        },
        SetOptions(merge: true),
      ); // Use merge to update existing data instead of overwriting

      print('User dashboard updated successfully for userId: $userId');
    } catch (e) {
      print('Error updating user dashboard: $e');
      rethrow;
    }
  }

  // Helper function to determine Tier Level based on total weight using TierCriteria
  String determineTierLevel(double totalWeightAllMaterials) {
    if (totalWeightAllMaterials >= TierCriteria.expert) {
      return 'Expert';
    } else if (totalWeightAllMaterials >= TierCriteria.explorer) {
      return 'Explorer';
    } else {
      return 'Newbie';
    }
  }
}
