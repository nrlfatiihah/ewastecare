import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/dashboard/new_user_dashboard_repository.dart';
import 'package:ewastecare/data/repositories/material/material_repository.dart';
import 'package:ewastecare/data/repositories/transaction/transaction_repository.dart';
import 'package:ewastecare/data/repositories/user/user_repository.dart';
import 'package:ewastecare/features/waste_point/model/add_point_model.dart';
import 'package:ewastecare/features/waste_point/model/material_model.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Adjust import as needed

class AllocateWastePointController extends GetxController {
  final MaterialRepository _materialRepository = MaterialRepository();

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

  // var dataFetched = false.obs;

  var expandedPanels = <bool>[].obs; // Track the expanded state of panels
  // var weightControllers = <String, TextEditingController>{}.obs; // Track weight input controllers
  Map<String, TextEditingController> weightControllers = {};

  var userID = TextEditingController();
  final addPointFormKey = GlobalKey<FormState>();
  final transactionCollection = TransactionRepository();
  final userRepository = UserRepository();
  final newUserDashboardRepository = NewUserDashboardRepository();

  bool dataFetched = false;

  @override
  void onInit() {
    super.onInit();
    fetchMaterialsAllocateScreen();
  }

  @override
  void onClose() {
    // Dispose of controllers when the screen is closed
    weightControllers.values.forEach((controller) => controller.dispose());
    super.onClose();
  }

  Future<void> fetchMaterialsAllocateScreen() async {
    try {
      // Fetch materials by type
      plasticMaterials.value = await _materialRepository.fetchAllMaterials(
        'Plastic',
      );
      paperMaterials.value = await _materialRepository.fetchAllMaterials(
        'Paper',
      );
      canMaterials.value = await _materialRepository.fetchAllMaterials('Can');
      oilMaterials.value = await _materialRepository.fetchAllMaterials(
        'Used Oil',
      );
      othersMaterials.value = await _materialRepository.fetchAllMaterials(
        'Others',
      );

      // dataFetched.value = true;

      // Set up controllers only for the relevant material types
      for (var material in plasticMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
      for (var material in paperMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
      for (var material in canMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
      for (var material in oilMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
      for (var material in othersMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
    } catch (e) {
      print("Error fetching materials: $e");
    }
  }

  // Method to group materials by category and prepare the data for saving
  Map<String, Map<String, double>> _prepareMaterialsForSaving() {
    Map<String, Map<String, double>> groupedMaterials = {
      'Plastic': {},
      'Paper': {},
      'Used Oil': {},
      'Can': {},
      'Others': {},
    };

    // Add materials to their respective groups
    for (var material in plasticMaterials) {
      final weight =
          double.tryParse(weightControllers[material.name]?.text ?? '') ?? 0.0;
      if (weight > 0) {
        groupedMaterials['Plastic']![material.name] = weight;
      } else {
        groupedMaterials['Plastic']![material.name] = 0.0;
      }
    }

    for (var material in paperMaterials) {
      final weight =
          double.tryParse(weightControllers[material.name]?.text ?? '') ?? 0.0;
      if (weight > 0) {
        groupedMaterials['Paper']![material.name] = weight;
      } else {
        groupedMaterials['Paper']![material.name] = 0.0;
      }
    }

    for (var material in canMaterials) {
      final weight =
          double.tryParse(weightControllers[material.name]?.text ?? '') ?? 0.0;
      if (weight > 0) {
        groupedMaterials['Can']![material.name] = weight;
      } else {
        groupedMaterials['Can']![material.name] = 0.0;
      }
    }

    for (var material in oilMaterials) {
      final weight =
          double.tryParse(weightControllers[material.name]?.text ?? '') ?? 0.0;
      if (weight > 0) {
        groupedMaterials['Used Oil']![material.name] = weight;
      } else {
        groupedMaterials['Used Oil']![material.name] = 0.0;
      }
    }

    for (var material in othersMaterials) {
      final weight =
          double.tryParse(weightControllers[material.name]?.text ?? '') ?? 0.0;
      if (weight > 0) {
        groupedMaterials['Others']![material.name] = weight;
      } else {
        groupedMaterials['Others']![material.name] = 0.0;
      }
    }

    return groupedMaterials;
  }

  // Method to group materials by category and prepare the data for saving
  Map<String, Map<String, double>> _preparePricesForSaving(
    Map<String, Map<String, double>> materials,
  ) {
    Map<String, Map<String, double>> groupedPrices = {
      'Plastic': {},
      'Paper': {},
      'Used Oil': {},
      'Can': {},
      'Others': {},
    };

    // Calculate prices for each material type
    for (var material in plasticMaterials) {
      final weight = materials['Plastic']?[material.name] ?? 0.0;
      final price = (weight * material.value).toStringAsFixed(
        2,
      ); // Calculate price by multiplying weight and value
      groupedPrices['Plastic']![material.name] = double.parse(price);
    }

    for (var material in paperMaterials) {
      final weight = materials['Paper']?[material.name] ?? 0.0;
      final price = (weight * material.value).toStringAsFixed(2);
      groupedPrices['Paper']![material.name] = double.parse(price);
    }

    for (var material in canMaterials) {
      final weight = materials['Can']?[material.name] ?? 0.0;
      final price = (weight * material.value).toStringAsFixed(2);
      groupedPrices['Can']![material.name] = double.parse(price);
    }

    for (var material in oilMaterials) {
      final weight = materials['Used Oil']?[material.name] ?? 0.0;
      final price = (weight * material.value).toStringAsFixed(2);
      groupedPrices['Used Oil']![material.name] = double.parse(price);
    }

    for (var material in othersMaterials) {
      final weight = materials['Others']?[material.name] ?? 0.0;
      final price = (weight * material.value).toStringAsFixed(2);
      groupedPrices['Others']![material.name] = double.parse(price);
    }

    return groupedPrices;
  }

  // Method to handle the point allocation process
  Future<void> addUserPoints() async {
    try {
      // Start loading
      WasteFullScreenLoader.openLoadingDialog(
        "We are processing your information...",
        WasteImages.docerAnimation,
      );

      // Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        WasteFullScreenLoader.stopLoading();
        // Get.snackbar("Error", "No internet connection.");
        WasteLoaders.errorSnackBar(
          title: "Oops!",
          message: "No internet connection.",
        );
        return;
      }
      // Form validation
      if (!addPointFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        // Get.snackbar("Error", "Form validation failed.");
        WasteLoaders.errorSnackBar(
          title: "Oops!",
          message: "Form validation failed.",
        );
        return;
      }
      // Prepare grouped materials data
      final materials = _prepareMaterialsForSaving();

      // Validate that at least one material has been filled
      bool hasMaterials = materials.values.any(
        (materialMap) => materialMap.isNotEmpty,
      );

      if (!hasMaterials) {
        WasteFullScreenLoader.stopLoading();
        // Get.snackbar("Error", "Form validation failed.");
        WasteLoaders.errorSnackBar(
          title: "Oops!",
          message: "Error: At least one material must be filled.",
        );
        return;
      }

      final prices = _preparePricesForSaving(materials);

      // Calculate total points (this is just an example, adjust based on your logic)
      // int totalPoints = await _materialRepository.calculateTotalPoints(materials);
      final result = await _materialRepository.calculateTotalPoints(materials);

      // Create a TransactionModel instance
      AllocatePoint transaction = AllocatePoint(
        transactionId: _generateTransactionId(), // Generate a unique ID
        userId: userID.text,
        totalPoints: result.finalPoints, // Total
        totalPrice: result.totalPrice, // Total
        transactionDate: DateTime.now(),
        materials: materials,
        prices: prices,
      );

      // Fetch existing points
      final existingPoints = await userRepository.fetchUserWastePoints(
        userID.text,
      );

      // Adding new point with existing points
      final newTotalPoints = existingPoints + result.finalPoints;

      // Update user points with new total points
      await userRepository.updateUserWastePoints(userID.text, newTotalPoints);

      // Save the transaction using the repository
      await _materialRepository.saveUserPoints(transaction);

      // log for transaction data
      await transactionCollection.AddPointLog(
        userId: userID.text,
        type: 'Add',
        // amount: roundedTotalPoints,
        amount: result.finalPoints,
        description: 'Waste Points Added',
      );

      // await newUserDashboardRepository.updateUserDashboardWithTransaction(transaction);

      await newUserDashboardRepository.updateUserDashboardWithTransaction(
        userId: userID.text,
        materials: materials,
        totalPoints: result.finalPoints, // Total
        totalPrice: result.totalPrice,
      );

      // Optionally, clear input fields or show success message
      clearFields();
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.successSnackBar(
        title: "Success",
        message:
            "${result.finalPoints} Point successfully added to the user account.",
      );
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  // Generate a unique transaction ID
  String _generateTransactionId() {
    return FirebaseFirestore.instance.collection('transactions').doc().id;
  }

  // Clear input fields after saving
  void clearFields() {
    userID.clear();
    weightControllers.forEach((key, controller) => controller.clear());
  }

  void resetDataFetched() {
    dataFetched = false;
  }
}
