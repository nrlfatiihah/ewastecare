import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/features/dashboard/models/user_dashboard_constant.dart';

class NewUserDashboardModel {
  String id;
  final Map<String, Map<String, double>> materials;
  int totalWastePoints;
  double totalWeightAllMaterials;
  String tierLevel;

  NewUserDashboardModel({
    required this.id,
    required this.materials,
    required this.totalWastePoints,
    required this.totalWeightAllMaterials,
    required this.tierLevel,
  });

  factory NewUserDashboardModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    // Check if document data is null and return an empty model if so
    if (document.data() == null) {
      print("Document data is null for userId: ${document.id}");
      print("no data");
      // return NewUserDashboardModel.empty();
    }

    // Fetch and log the document data
    final data = document.data()!;
    print("Document data from snapshot: ${data}");
    print("TierLevel data from snapshot: ${data['TierLevel']}");

    // Check if 'materials' exists and is of the correct type
    if (data.containsKey("materials") &&
        data["materials"] is Map<String, dynamic>) {
      final materials = (data["materials"] as Map<String, dynamic>).map((
        key,
        value,
      ) {
        if (value is! Map<String, dynamic>)
          return MapEntry(key, <String, double>{});
        final subMap = value;
        return MapEntry(
          key,
          subMap.map((k, v) => MapEntry(k, (v is num ? v.toDouble() : 0.0))),
        );
      });

      print("Parsed materials here: $materials"); // Log parsed materials

      print("Returning model with ID: ${document.id}");
      print("Materials: $materials");
      print("Total Waste Points: ${data["totalWastePoints"]}");
      print("Total Weight All Materials: ${data["totalWeightAllMaterials"]}");
      print("Tier Level: ${data["TierLevel"]}");

      try {
        final model = NewUserDashboardModel(
          id: document.id,
          materials: materials,
          totalWastePoints: (data["totalWastePoints"] as num)
              .toInt(), // Converts to int if needed
          totalWeightAllMaterials: (data["totalWeightAllMaterials"] as num)
              .toDouble(), // Ensures double type
          tierLevel: data["TierLevel"],
        );
        print("Successfully created model: $model");
        return model;
      } catch (e) {
        print("Error creating model: $e");
        return NewUserDashboardModel.empty();
      }
    } else {
      // Only reach this point if 'materials' data is missing or incorrectly formatted
      print(
        "Materials data not found or incorrect format for userId: ${document.id}",
      );
      return NewUserDashboardModel.empty();
    }
  }

  void updateTier() {
    // Only update the tier if it's different from what we have in Firestore
    if (tierLevel == 'Expert' ||
        tierLevel == 'Explorer' ||
        tierLevel == 'Newbie') {
      return; // Skip the update if tierLevel is already set
    }

    // Use totalWastePoints or totalWeightAllMaterials to determine the tier
    if (totalWeightAllMaterials >= TierCriteria.expert) {
      tierLevel = 'Expert';
    } else if (totalWeightAllMaterials >= TierCriteria.explorer) {
      tierLevel = 'Explorer';
    } else {
      tierLevel = 'Newbie';
    }
  }

  double getProgress() {
    double progress = 0.0;
    double totalCollectedMaterials = totalWeightAllMaterials;
    if (tierLevel == 'Newbie') {
      progress = totalCollectedMaterials / TierCriteria.explorer;
    } else if (tierLevel == 'Explorer') {
      progress =
          (totalCollectedMaterials - TierCriteria.explorer) /
          (TierCriteria.expert - TierCriteria.explorer);
    } else if (tierLevel == 'Expert') {
      progress = 1.0; // Expert tier, progress is complete
    }
    return progress;
  }

  String getNextTier() {
    if (tierLevel == 'Newbie') {
      return 'Explorer';
    } else if (tierLevel == 'Explorer') {
      return 'Expert';
    } else {
      return 'none'; // Already at highest tier
    }
  }

  double getNextTierThreshold() {
    if (tierLevel == 'Newbie') {
      return TierCriteria.explorer.toDouble();
    } else if (tierLevel == 'Explorer') {
      return TierCriteria.expert.toDouble();
    } else {
      return totalWeightAllMaterials; // For expert, return the current total as there's no next tier
    }
  }

  // Provide a method to return an empty instance if needed
  factory NewUserDashboardModel.empty() {
    return NewUserDashboardModel(
      id: '',
      materials: {},
      totalWastePoints: 0,
      totalWeightAllMaterials: 0.0,
      tierLevel: 'Newbie',
    );
  }
}
