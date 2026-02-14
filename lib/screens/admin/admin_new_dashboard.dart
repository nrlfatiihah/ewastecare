import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/data/repositories/dashboard/admin_dashboard_repository.dart';
import 'package:ewastecare/data/repositories/dashboard/new_admin_dashboard_repository.dart';
import 'package:ewastecare/models/material_models.dart';

class AdminDashboardService extends GetxController {
  static AdminDashboardService get instance = Get.put(
    AdminDashboardService(),
  );

  final newAdminDashboardRepository = NewAdminDashboardRepository();

  var isLoading = false.obs;
  var isPlasticExpanded = false.obs;
  var isPaperExpanded = false.obs;
  var isCanExpanded = false.obs;
  var isCookingOilExpanded = false.obs;
  var isOthersExpanded = false.obs;

  var plasticMaterials = <MaterialModel>[].obs;
  var paperMaterials = <MaterialModel>[].obs;
  var canMaterials = <MaterialModel>[].obs;
  var cookingOilMaterials = <MaterialModel>[].obs;
  var otherMaterials = <MaterialModel>[].obs;

  var dataFetched = false.obs;

  var detailedWeights = <String, Map<String, double>>{}.obs;
  var materialGroupWeights = <String, double>{}.obs;
  var materialGroupPercentages = <String, double>{}.obs;
  var selectedStartDate = Rxn<DateTime>();
  var selectedEndDate = Rxn<DateTime>();
  var displaySumOfAllMaterials = 0.0.obs;
  var displaySumOfWastePoints = 0.obs;
  var totalActiveUsers = 0.obs;
  var mostPerformantUser = ''.obs;
  var mostPerformantUsername = ''.obs;
  var maleUsers = 0.obs;
  var femaleUsers = 0.obs;
  var totalUsers = 0.obs;

  double sumOfAllMaterials = 0.0;
  int sumOfWastePoints = 0;

  @override
  void onInit() {
    super.onInit();
    fetchRateMaterials();
    fetchMaterialWeights();
    calculateWeights();
    fetchUserStatistics();
  }

  double roundToTwoDecimalPlaces(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  Map<String, Map<String, double>> detailedMaterialWeights = {
    'Plastic': {},
    'Paper': {},
    'Can': {},
    'Used Oil': {},
    'Others': {},
  };

  Future<void> fetchRateMaterials() async {
    print("Calling fetchRateMaterials in process");
    try {
      plasticMaterials.value =
          await newAdminDashboardRepository.fetchAllMaterials('Plastic');
      paperMaterials.value =
          await newAdminDashboardRepository.fetchAllMaterials('Paper');
      canMaterials.value =
          await newAdminDashboardRepository.fetchAllMaterials('Can');
      cookingOilMaterials.value =
          await newAdminDashboardRepository.fetchAllMaterials('Used Oil');
      otherMaterials.value =
          await newAdminDashboardRepository.fetchAllMaterials('Others');

      dataFetched.value = true;
    } catch (e) {
      print("Error in fetchRateMaterials: $e");
    }
  }

  Future<void> fetchMaterialWeights() async {
    isLoading.value = true;
    final List<Map<String, dynamic>> allData =
        await newAdminDashboardRepository.fetchAllAdminDashboardData();
    
    print("Fetched all admin dashboard data: $allData");

    final Map<String, double> allWeights = {};
    for (var item in allData) {
      if (item['materials'] is Map<String, dynamic>) {
        final materials = item['materials'] as Map<String, dynamic>;

        print("Processing materials: $materials");

        for (var entry in materials.entries) {
          final materialName = entry.key;
          final weight = entry.value;

          if (weight is num) {
            allWeights[materialName] =
                (allWeights[materialName] ?? 0) + weight.toDouble();
          } else {
            print("Materials field missing or not a Map in item: $item");
          }
        }
      }
    }

    print("All weights map without date filter: ");
    allWeights.forEach((material, weight) {
      print("Material: $material, Total Weight: $weight");
    });

    materialGroupWeights.assignAll(allWeights);
  }

  Future<void> fetchUserStatistics() async {
    try {
      final genderStats = await newAdminDashboardRepository
          .fetchGenderStatistics();
      maleUsers.value = genderStats['maleUsers'] ?? 0;
      femaleUsers.value = genderStats['femaleUsers'] ?? 0;
    } catch (e) {
      totalUsers.value = 0;
      maleUsers.value = 0;
      femaleUsers.value = 0;
    }
  }

  Future<void> calculateMaterialWeights() async {
    await Future.delayed(const Duration(seconds: 1));

    // Clear previous total
    sumOfAllMaterials = 0.0;
    sumOfWastePoints = 0;
    materialGroupWeights.clear();
    detailedMaterialWeights.clear();
    materialGroupPercentages.clear();
    final activeUser = <String>{};
    final userTotals = <String, double>{};

    // Reinitialize detailedMaterialWeights with default structure
    detailedMaterialWeights = {
      'Plastic': {},
      'Paper': {},
      'Can': {},
      'Used Oil': {},
      'Others': {},
    };

    print("Starting calculateMaterialWeights from scratch");

    try {
      final data = await newAdminDashboardRepository
          .fetchAllAdminDashboardData();
      print("Fetched data: $data");

      Map<String, double> calculatedWeights = {};
      for (var document in data) {
        sumOfAllMaterials += document['totalWeightAllMaterials'] ?? 0.0;
        sumOfAllMaterials =
            roundToTwoDecimalPlaces(sumOfAllMaterials);
        print("Updated sumOfAllMaterials: $sumOfAllMaterials");

        sumOfWastePoints += (document['totalWastePoints'] as num).toInt();
        print("Updated sumOfWastePoints: $sumOfWastePoints");

        activeUser.add(document['UserID']?.toString() ?? '');
        print("Updated activeUser: $activeUser");

        final userId = document['UserID']?.toString() ?? '';
        if (userId.isNotEmpty){
          userTotals.update(userId, (value) => value + 1, ifAbsent: () => 1);
        }

        final materials = document['materials'] as Map<String, dynamic>?;
        print("Materials in document: $materials");

        materials?.forEach((group, items) {
          if (items is Map<String, dynamic>) {
            double groupTotal = 0.0;

            // Sum weights of items within the group
            items.forEach((item, weight) {
              double weightValue = (weight as num).toDouble();
              groupTotal += weightValue;

              // Add item weight to the corresponding item
              if (detailedMaterialWeights.containsKey(group)) {
                detailedMaterialWeights[group]?[item] =
                  roundToTwoDecimalPlaces(
                    (detailedMaterialWeights[group]?[item] ?? 0.0) +
                    weightValue);
              } else {
                detailedMaterialWeights[group] = {
                  item: weightValue
                };
              }
            });
            groupTotal = roundToTwoDecimalPlaces(groupTotal);

            calculatedWeights[group] =
              roundToTwoDecimalPlaces((calculatedWeights[group] ?? 0) + groupTotal);
          }
        });
      }
      materialGroupWeights.assignAll(calculatedWeights);

      // Calculate percentages for each material group
      Map<String, double> calculatedPercentages = {};
      materialGroupWeights.forEach((group, weight) {
        double percentage = (weight / sumOfAllMaterials * 100);
        calculatedPercentages[group] = roundToTwoDecimalPlaces(percentage);
        print("Calculated percentage for group '$group': ${calculatedPercentages[group]}");
      }); 

      // Update RxMap with calculated values
      materialGroupPercentages.assignAll(calculatedPercentages);

      // Final print statements for verifying all calculations
      print('Final Material Group Weights: $materialGroupWeights');
      print('Final Item Weights By Group: $detailedMaterialWeights');
      print('Final Material Group Percentages: $materialGroupPercentages');
      print('Sum of All Materials: $sumOfAllMaterials');
      print('Sum of Waste Points: $sumOfWastePoints');
    } catch (e) {
      print("Error in calculateMaterialWeights: $e");
    }

    displaySumOfAllMaterials.value = sumOfAllMaterials;
    displaySumOfWastePoints.value = sumOfWastePoints;
    totalActiveUsers.value = activeUser.length;

    if (userTotals.isNotEmpty) {
      final mostPerformantUserEntry = userTotals.entries.reduce((a,b) => a.value > b.value ? a : b);
      mostPerformantUser.value = mostPerformantUserEntry.key;
      await fetchUsernameByUserId(mostPerformantUser.value);
    } else {
      mostPerformantUser.value = '';
      mostPerformantUsername.value = '';
    }
  }

  Future<void> calculateMaterialWeightByFilterDate([DateTime? selectedStartDate2, DateTime? selectedEndDate2]) async {
    print("Selected Start Date2: $selectedStartDate2");
    print("Selected End Date2: $selectedEndDate2");

    if (selectedStartDate2 == null || selectedEndDate2 == null) {
      print("Error: Start date or end date is null");
      return;
    }

    // Clear previous totals 
    sumOfAllMaterials = 0.0;
    sumOfWastePoints = 0;
    materialGroupWeights.clear();
    detailedMaterialWeights.clear();
    materialGroupPercentages.clear();
    final activeUser = <String>{};
    final userTotals = <String, int>{};

    // Reinitialize detailedMaterialWeights with the default structure
    detailedMaterialWeights = {
      'Plastic': {},
      'Paper': {},
      'Can': {},
      'Used Oil': {},
      'Others': {},
    };

    print("Starting calculateMaterialWeightsByFilterDate from scratch");

    try {
      // Fetch data from repository
      final data = await newAdminDashboardRepository.fetchAllAdminDashboardDataByDateFilter(
        selectedStartDate2, selectedEndDate2,
      );
      await Future.delayed(
        const Duration(seconds: 1));
      Map<String, double> calculatedWeights = {};

      for (var document in data) {
        sumOfAllMaterials += (document['totalWeightAllMaterials'] ?? 0.0);
        sumOfAllMaterials = roundToTwoDecimalPlaces(sumOfAllMaterials);
        print("Updated sumOfAllMaterials: $sumOfAllMaterials");

        sumOfWastePoints += (document['totalWastePoints'] as num).toInt();
        
        activeUser.add(document['UserID']?.toString() ?? '');
        print("Updated activeUser: $activeUser");

        final userId = document['UserID']?.toString() ?? '';
        if (userId.isNotEmpty) {
          userTotals.update(userId, (value) => value + 1, ifAbsent: () => 1);
        }

        final materials = document['materials'] as Map<String,dynamic>;
        print("Materials in document: $materials");

        // Process each material group
        materials.forEach((group, items) {
          if (items is Map<String, dynamic>) {
            double groupTotal = 0.0;

            // Sum weights of items within group
            items.forEach((item, weight) {
              double weightValue = (weight as num).toDouble();
              groupTotal += weightValue;

              // Add item weight to the corresponding item
              if (detailedMaterialWeights.containsKey(group)) {
                detailedMaterialWeights[group]?[item] = roundToTwoDecimalPlaces((detailedMaterialWeights[group]?[item] ?? 0.0) + weightValue);
              } else {
                detailedMaterialWeights[group] = {item:weightValue};
              }
            });

            // Round groupTotal to 2 decimal places
            groupTotal = roundToTwoDecimalPlaces(groupTotal);

            // Add group total to the corresponding material group in the map
            calculatedWeights[group] = roundToTwoDecimalPlaces((calculatedWeights[group] ?? 0) + groupTotal);
            print("Updated materialGroupWeights for group '$group': ${materialGroupWeights[group]}");
          }
        });
      }
      materialGroupWeights.assignAll(calculatedWeights);

      // Ensure the total weight is not zero to avoid division by zero
      if (sumOfAllMaterials == 0) {
        print('Sum of all materials is zero. Cannot calculate percentages.');
        return;
      }

      //Calculate percentages for each material group
      Map<String, double> calculatedPercentages = {};
      materialGroupWeights.forEach((group, weight) {
        double percentage = (weight / sumOfAllMaterials * 100);
        calculatedPercentages[group] = roundToTwoDecimalPlaces(percentage);
        print("Calculated percentage for group '$group': ${calculatedPercentages[group]}");
      });

      // Update RxMap with calculated values
      materialGroupPercentages.assignAll(calculatedPercentages);

      // Print statements for debugging and verifying values
      print('Material Group Weights by date: $materialGroupWeights');
      print('Item Weights By Group by date: $detailedMaterialWeights');
      print('Material Group Percentages by date: $materialGroupPercentages');
      print('Sum of All Materials by date: $sumOfAllMaterials');
    } catch (e) {
      print("Error in calculateMaterialWeightsByFilterDate: $e");
    }
    displaySumOfAllMaterials.value = sumOfAllMaterials;
    displaySumOfWastePoints.value = sumOfWastePoints;
    totalActiveUsers.value = activeUser.length;

    if (userTotals.isNotEmpty) {
      final mostPerformantUserEntry = 
            userTotals.entries.reduce((a,b) => a.value > b.value ? a : b);
      mostPerformantUser.value = mostPerformantUserEntry.key;
      await fetchUsernameByUserId(mostPerformantUser.value);
    } else {
      mostPerformantUser.value = '';
      mostPerformantUsername.value = '';
    }
  }

  // Function to manage expansion panel state
 Map<String, bool> expandedPanels = {
    'Plastic': false,
    'Paper': false,
    'Can': false,
    'Used Oil': false,
    'Others': false,
  };

  void resetDataFetched() {
    dataFetched.value = false;
  }

  Future<void> calculateWeights() async {
    // Check if date filter is applied
    if (selectedStartDate.value != null && selectedEndDate.value != null) {
      // Call the method to calculate weights by filtering with date range
      await calculateMaterialWeightByFilterDate(
          selectedStartDate.value, selectedEndDate.value);
    } else {
      // No date filter, calculate weights without any date restrictions
      await calculateMaterialWeights();
    }
  }

  Future<void> fetchUsernameByUserId(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        mostPerformantUsername.value = userDoc.data()?['Username'] ?? '';
      } else {
        mostPerformantUsername.value = 'Unknown User';
      }
    } catch (e) {
      mostPerformantUsername.value = 'Error fetching username';
    }
  }
}