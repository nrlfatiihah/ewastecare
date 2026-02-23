import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/dashboard/admin_dashboard_repository.dart';
import 'package:ewastecare/data/repositories/dashboard/user_dashboard_repository.dart';
import 'package:ewastecare/data/repositories/transaction/transaction_repository.dart';
import 'package:ewastecare/data/repositories/user/user_repository.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OlderAdminPointController extends GetxController {
  static OlderAdminPointController get instance => Get.find();

  final userID = TextEditingController();
  final petWeight = TextEditingController();
  final hdpeWeight = TextEditingController();
  final ppWeight = TextEditingController();
  final booksWeight = TextEditingController();
  final newspaperWeight = TextEditingController();
  final cardboardWeight = TextEditingController();
  GlobalKey<FormState> addPointFormKey = GlobalKey<FormState>();
  final userRepository = UserRepository();
  final transactionCollection = TransactionRepository();
  final userDashboardRepository = UserDashboardRepository();
  final adminDashboardRepository = AdminDashboardRepository();

  final isPlasticExpanded = true.obs;
  final isPaperExpanded = false.obs;
  final isCanExpanded = false.obs;
  final isCookingOilExpanded = false.obs;
  final isOthersExpanded = false.obs;

  bool dataFetched = false;

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

      // Retrieve values entered by admin
      String userid = userID.text;
      double petWeightValue;
      double hdpeWeightValue;
      double ppWeightValue;

      // Parse the weights, handle potential parsing errors
      try {
        petWeightValue = double.parse(petWeight.text);
      } catch (e) {
        WasteFullScreenLoader.stopLoading();
        // Get.snackbar("Error", "Invalid PET Weight value.");
        WasteLoaders.errorSnackBar(
          title: "Oops!",
          message: "Invalid PET Weight value.",
        );
        return;
      }

      try {
        hdpeWeightValue = double.parse(hdpeWeight.text);
      } catch (e) {
        WasteFullScreenLoader.stopLoading();
        // Get.snackbar("Error", "Invalid HDPE Weight value.");
        WasteLoaders.errorSnackBar(
          title: "Oops!",
          message: "Invalid HDPE Weight value.",
        );
        return;
      }

      try {
        ppWeightValue = double.parse(ppWeight.text);
      } catch (e) {
        WasteFullScreenLoader.stopLoading();
        // Get.snackbar("Error", "Invalid PP Weight value.");
        WasteLoaders.errorSnackBar(
          title: "Oops!",
          message: "Invalid PP Weight value.",
        );
        return;
      }

      // Calculate points based on weights and material prices
      double petPoints = petWeightValue * MaterialPrices.petPrice;
      double hdpePoints = hdpeWeightValue * MaterialPrices.hdpePrice;
      double ppPoints = ppWeightValue * MaterialPrices.ppPrice;
      // Calculate total points earned
      double totalPoints = petPoints + hdpePoints + ppPoints;

      // make it into 2 decimal places without round up
      double truncatedTotalPoints =
          (totalPoints * 100).truncateToDouble() / 100;

      // multiply by 100 to make it into logical points
      int finalTotalPoints = (truncatedTotalPoints * 100)
          .toInt(); // Multiply by 100

      // Fetch existing points
      final existingPoints = await userRepository.fetchUserEcoPoints(userid);

      // Adding new point with existing points
      final newTotalPoints = existingPoints + finalTotalPoints;

      // Update user points with new total points
      await userRepository.updateUserEcoPoints(userid, newTotalPoints);

      // log for transaction data

      await transactionCollection.logTransaction(
        userId: userid,
        type: 'Add',
        // amount: roundedTotalPoints,
        amount: finalTotalPoints,
        description: 'Waste Points Added',
      );

      // Update user dashboard data
      // await userDashboardRepository.updateUserDashboardData(
      //   userid,
      //   ppWeightValue,
      //   petWeightValue,
      //   hdpeWeightValue,
      //   finalTotalPoints,
      // );

      // Update admin dashboard data
      await adminDashboardRepository.addAdminDashboardData(
        userid,
        ppWeightValue,
        petWeightValue,
        hdpeWeightValue,
        finalTotalPoints,
      );

      // Stop loading and show success message
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.successSnackBar(
        title: "Success",
        message:
            "$finalTotalPoints Point successfully added to the user account.",
      );
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  void clearFields() {
    userID.clear();
    petWeight.clear();
    hdpeWeight.clear();
    ppWeight.clear();
  }

  void resetDataFetched() {
    dataFetched = false;
  }
}

class MaterialPrices {
  static const double petPrice = 0.15; // Price per kg for PET
  static const double hdpePrice = 0.15; // Price per kg for HDPE
  static const double ppPrice = 0.15; // Price per kg for PP
}
