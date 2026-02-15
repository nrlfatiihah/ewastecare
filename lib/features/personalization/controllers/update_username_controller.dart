import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/user/user_repository.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:ewastecare/features/personalization/screens/profile/profile.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUserNameController extends GetxController {
  static UpdateUserNameController get instance => Get.find();

  final userName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  // init user data when home screen appear
  @override
  void onInit() {
    initializedName();
    super.onInit();
  }

  // fetch user record
  Future<void> initializedName() async {
    userName.text = userController.user.value.username;
  }

  Future<void> updateUserName2() async {
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
      if (!updateUserNameFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      //Update user's first name and last name is the firebase firestore
      Map<String, dynamic> name = {"Username": userName.text.trim()};
      await userRepository.updateSingleField(name);

      // Update the RX user value
      userController.user.value.username = userName.text.trim();

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
