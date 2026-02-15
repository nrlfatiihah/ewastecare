import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/data/repositories/dashboard/admin_dashboard_repository.dart';
import 'package:ewastecare/data/repositories/dashboard/new_admin_dashboard_repository.dart';
import 'package:ewastecare/features/ecobako_point/model/material_model.dart';
import 'package:get/get.dart';

class AdminDashboardService extends GetxController {
  static AdminDashboardService get instance => Get.put(AdminDashboardService());
  final newAdminDashboardRepository = NewAdminDashboardRepository();
  // Observables for expansion states
  var isLoading = false.obs;
  var isPlasticExpanded = false.obs;
  var isPaperExpanded = false.obs;
  var isCanExpanded = false.obs;
  var isCookingOilExpanded = false.obs;
  var isOthersExpanded = false.obs;

  var plasticMaterials = <MaterialModel>[].obs;
  var paperMaterials = <MaterialModel>[].obs;
  var canMaterials = <MaterialModel>[].obs;
  var oilMaterials = <MaterialModel>[].obs;
  var othersMaterials = <MaterialModel>[].obs;

  var dataFetched = false.obs;

  // Observables for detailed weights
  var detailedWeights = <String, Map<String, double>>{}.obs;
  var materialGroupWeights = <String, double>{}.obs;
  var materialGroupPercentages = <String, double>{}.obs;
  var selectedStartDate = Rxn<DateTime>();
  var selectedEndDate = Rxn<DateTime>();
  var displaySumOfAllMaterials = 0.0.obs;
  var displaySumOfWastePoints = 0.obs;
  var totalActiveUser = 0.obs;
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

  // Map to store percentages by material group
  // Map<String, double> materialGroupPercentages = {};

  // Map to store weights by individual items within each material group
  Map<String, Map<String, double>> detailedMaterialWeights = {
    'Plastic': {},
    'Paper': {},
    'Can': {},
    'Used Oil': {},
    'Others': {},
  };

  Future<void> fetchRateMaterials() async {
    print("calling fetchRateMaterials in process");
    try {
      // Fetching materials from the repository based on the material type
      plasticMaterials.value = await newAdminDashboardRepository
          .fetchAllMaterials('Plastic');
      paperMaterials.value = await newAdminDashboardRepository
          .fetchAllMaterials('Paper');
      canMaterials.value = await newAdminDashboardRepository.fetchAllMaterials(
        'Can',
      );
      oilMaterials.value = await newAdminDashboardRepository.fetchAllMaterials(
        'Used Oil',
      );
      othersMaterials.value = await newAdminDashboardRepository
          .fetchAllMaterials('Others');

      dataFetched.value = true; // Mark data as fetched
    } catch (e) {
      print("Error fetching materials: $e");
    }
  }

  Future<void> fetchMaterialWeights() async {
    // Fetch all data if no date is selected
    isLoading.value = true;
    final List<Map<String, dynamic>> allData = await newAdminDashboardRepository
        .fetchAllAdminDashboardData();

    print("Fetched all data without date filter: $allData");

    // Initialize weights map
    final Map<String, double> allWeights = {};

    for (var item in allData) {
      // Check if the 'materials' field exists and is a Map
      if (item['materials'] is Map<String, dynamic>) {
        final materials = item['materials'] as Map<String, dynamic>;

        print("Processing materials: $materials");

        for (var entry in materials.entries) {
          final material = entry.key;
          final weight = entry.value;

          // Check if the weight is a number and convert it to double
          if (weight is num) {
            allWeights[material] =
                (allWeights[material] ?? 0) + weight.toDouble();
          } else {
            print("Materials field missing or not a Map in item: $item");
          }
        }
      }
    }

    // Print out the final allWeights map
    print("All weights map without date filter:");
    allWeights.forEach((material, weight) {
      print("Material: $material, Total Weight: $weight");
    });

    // Update the RxMap with the calculated weights
    materialGroupWeights.assignAll(allWeights);
  }

  Future<void> fetchMaterialWeightsbyFilterData([
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
  ]) async {
    isLoading.value = true;
    print(
      "Test this time for fetchMaterialWeightsbyFilterData function: $selectedStartDate",
    );
    final List<Map<String, dynamic>> data = await newAdminDashboardRepository
        .fetchAllAdminDashboardDataByDateFilter(
          selectedStartDate,
          selectedEndDate,
        );

    print("Fetched data with date filter: $data");

    // Initialize weights map
    final Map<String, double> weights = {};

    for (var item in data) {
      // Check if the 'materials' field exists and is a Map
      if (item['materials'] is Map<String, dynamic>) {
        final materials = item['materials'] as Map<String, dynamic>;

        print("Processing materials: $materials");

        for (var entry in materials.entries) {
          final material = entry.key;
          final weight = entry.value;

          // Check if the weight is a number and convert it to double
          if (weight is num) {
            weights[material] = (weights[material] ?? 0) + weight.toDouble();
          } else {
            print("Materials field missing or not a Map in item: $item");
          }
        }
      }
    }

    // Print out the final weights map
    print("Weights map for selected date range:");
    weights.forEach((material, weight) {
      print("Material: $material, Total Weight: $weight");
    });

    // Update the RxMap with the calculated weights
    materialGroupWeights.assignAll(weights);
  }

  Future<void> fetchUserStatistics() async {
    try {
      // totalUsers.value = await adminDashboardRepository.fetchTotalUsers();

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
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simulate delay for testing

    // Clear previous totals to start fresh
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

    print("Starting calculateMaterialWeights from scratch");

    try {
      // Fetch data from repository
      final data = await newAdminDashboardRepository
          .fetchAllAdminDashboardData();
      print("Fetched data: $data");

      Map<String, double> calculatedWeights = {};
      for (var document in data) {
        // Add to overall total weight
        sumOfAllMaterials += (document['totalWeightAllMaterials'] ?? 0.0);
        sumOfAllMaterials = roundToTwoDecimalPlaces(sumOfAllMaterials);
        print("Updated sumOfAllMaterials: $sumOfAllMaterials");

        sumOfWastePoints += (document['totalWastePoints'] as num).toInt();
        print("Updated sumOfWaste: $sumOfWastePoints");

        activeUser.add(
          document['UserID']?.toString() ?? '',
        ); // Convert to String safely
        print("Updated activeUser: $activeUser");

        final userId = document['UserID']?.toString() ?? '';
        if (userId.isNotEmpty) {
          userTotals.update(userId, (value) => value + 1, ifAbsent: () => 1);
        }
        ;

        // Extract materials data
        final materials = document['materials'] as Map<String, dynamic>;
        print("Materials in document: $materials");

        // Process each material group

        materials.forEach((group, items) {
          if (items is Map<String, dynamic>) {
            double groupTotal = 0.0;

            // Sum weights of items within the group
            items.forEach((item, weight) {
              double weightValue = (weight as num).toDouble();
              groupTotal += weightValue;

              // Add item weight to the corresponding item in the map
              if (detailedMaterialWeights.containsKey(group)) {
                detailedMaterialWeights[group]?[item] = roundToTwoDecimalPlaces(
                  (detailedMaterialWeights[group]?[item] ?? 0.0) + weightValue,
                );
              } else {
                detailedMaterialWeights[group] = {item: weightValue};
              }
            });
            groupTotal = roundToTwoDecimalPlaces(groupTotal);

            // Add group total to the corresponding material group in the map
            calculatedWeights[group] = roundToTwoDecimalPlaces(
              (calculatedWeights[group] ?? 0) + groupTotal,
            );
          }
        });
      }
      materialGroupWeights.assignAll(calculatedWeights);

      // Calculate percentages for each material group
      Map<String, double> calculatedPercentages = {};
      materialGroupWeights.forEach((group, weight) {
        double percentage = (weight / sumOfAllMaterials * 100);
        calculatedPercentages[group] = roundToTwoDecimalPlaces(percentage);
        print(
          "Calculated percentage for group '$group': ${calculatedPercentages[group]}",
        );
      });

      // Update RxMap with calculated values
      materialGroupPercentages.assignAll(calculatedPercentages);

      // Final print statements for verifying all calculations
      print('Final Material Group Weights: $materialGroupWeights');
      print('Final Item Weights By Group: $detailedMaterialWeights');
      print('Final Material Group Percentages: $materialGroupPercentages');
      print('Sum of All Materials: $sumOfAllMaterials');
      print('Sum of Wastes: $sumOfWastePoints');
    } catch (e) {
      print("Error in calculateMaterialWeights: $e");
    }

    displaySumOfAllMaterials.value = sumOfAllMaterials;
    displaySumOfWastePoints.value = sumOfWastePoints;
    totalActiveUser.value = activeUser.length;

    if (userTotals.isNotEmpty) {
      final mostPerformantUserEntry = userTotals.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      mostPerformantUser.value = mostPerformantUserEntry.key;
      await fetchUsernameByUserId(mostPerformantUser.value);
    } else {
      mostPerformantUser.value = '';
      mostPerformantUsername.value = '';
    }
  }

  Future<void> calculateMaterialWeightsByFilterDate([
    DateTime? selectedStartDate2,
    DateTime? selectedEndDate2,
  ]) async {
    print("Selected Start Date2: $selectedStartDate2");
    print("Selected End Date2: $selectedEndDate2");

    if (selectedStartDate2 == null || selectedEndDate2 == null) {
      print("Error: Start date or end date is null");
      return;
    }

    // Clear previous totals to start fresh
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
      final data = await newAdminDashboardRepository
          .fetchAllAdminDashboardDataByDateFilter(
            selectedStartDate2,
            selectedEndDate2,
          );
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate delay for testing
      Map<String, double> calculatedWeights = {};

      for (var document in data) {
        // Add to overall total weight
        sumOfAllMaterials += (document['totalWeightAllMaterials'] ?? 0.0);
        sumOfAllMaterials = roundToTwoDecimalPlaces(
          sumOfAllMaterials,
        ); // Round to 2 decimal places
        print("Updated sumOfAllMaterials: $sumOfAllMaterials");

        sumOfWastePoints += (document['totalWastePoints'] as num).toInt();

        activeUser.add(
          document['UserID']?.toString() ?? '',
        ); // Convert to String safely
        print("Updated activeUser: $activeUser");

        final userId = document['UserID']?.toString() ?? '';
        if (userId.isNotEmpty) {
          userTotals.update(userId, (value) => value + 1, ifAbsent: () => 1);
        }
        ;

        // Extract materials data
        final materials = document['materials'] as Map<String, dynamic>;
        print("Materials in document: $materials");

        // Process each material group
        materials.forEach((group, items) {
          if (items is Map<String, dynamic>) {
            double groupTotal = 0.0;

            // Sum weights of items within the group
            items.forEach((item, weight) {
              double weightValue = (weight as num).toDouble();
              groupTotal += weightValue;

              // Add item weight to the corresponding item in the map
              if (detailedMaterialWeights.containsKey(group)) {
                detailedMaterialWeights[group]?[item] = roundToTwoDecimalPlaces(
                  (detailedMaterialWeights[group]?[item] ?? 0.0) + weightValue,
                );
              } else {
                detailedMaterialWeights[group] = {item: weightValue};
              }
            });

            // Round groupTotal to 2 decimal places
            groupTotal = roundToTwoDecimalPlaces(groupTotal);

            // Add group total to the corresponding material group in the map
            calculatedWeights[group] = roundToTwoDecimalPlaces(
              (calculatedWeights[group] ?? 0) + groupTotal,
            );
            print(
              "Updated materialGroupWeights for group '$group': ${materialGroupWeights[group]}",
            );
          }
        });
      }
      materialGroupWeights.assignAll(calculatedWeights);

      // Ensure the total weight is not zero to avoid division by zero
      if (sumOfAllMaterials == 0) {
        print('Sum of all materials is zero. Cannot calculate percentages.');
        return;
      }

      // Calculate percentages for each material group
      Map<String, double> calculatedPercentages = {};
      materialGroupWeights.forEach((group, weight) {
        double percentage = (weight / sumOfAllMaterials * 100);
        calculatedPercentages[group] = roundToTwoDecimalPlaces(
          percentage,
        ); // Round to 2 decimal places
        print(
          "Calculated percentage for group '$group': ${calculatedPercentages[group]}",
        );
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
    totalActiveUser.value = activeUser.length;

    if (userTotals.isNotEmpty) {
      final mostPerformantUserEntry = userTotals.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
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
      await calculateMaterialWeightsByFilterDate(
        selectedStartDate.value,
        selectedEndDate.value,
      );
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
