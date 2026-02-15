// use anc checked
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/user/user_repository.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:ewastecare/features/personalization/screens/profile/profile.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateHomeAddressController extends GetxController {
  static UpdateHomeAddressController get instance => Get.find();

  final homeAddress = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateHomeAddressFormKey = GlobalKey<FormState>();

  // init user data when home screen appear
  @override
  void onInit() {
    initializedName();
    super.onInit();
  }

  // fetch user record
  Future<void> initializedName() async {
    homeAddress.text = userController.user.value.homeAddress;
  }

  Future<void> updateHomeAddress() async {
    try {
      // Start the loading animation
      WasteFullScreenLoader.openLoadingDialog(
        "Updating your information",
        WasteImages.docerAnimation,
      );

      // Check Internet Commection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!updateHomeAddressFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      //Update user's first name and last name is the firebase firestore
      Map<String, dynamic> name = {"Address": homeAddress.text.trim()};
      await userRepository.updateSingleField(name);

      // Update the RX user value
      userController.user.value.homeAddress = homeAddress.text.trim();

      // Remove loader
      WasteFullScreenLoader.stopLoading();

      // Show Succcess message
      WasteLoaders.successSnackBar(
        title: "Success",
        message: "Your name has been updated.",
      );

      // Move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oh Sanp", message: e.toString());
    }
  }
}
