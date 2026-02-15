// use and checked
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      // Loading animation
      WasteFullScreenLoader.openLoadingDialog(
        "Processing your request",
        WasteImages.docerAnimation,
      );

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      //Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(
        email.text.trim(),
      );

      // Remove loader
      WasteFullScreenLoader.stopLoading();

      // Show Success Screen
      WasteLoaders.successSnackBar(
        title: "Email sent",
        message: "Email Link Sent to Reset Password",
      );

      // Redirect
      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops", message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      try {
        // Loading animation
        WasteFullScreenLoader.openLoadingDialog(
          "Processing your request",
          WasteImages.docerAnimation,
        );

        // Check internet connection
        final isConnected = await NetworkManager.instance.isConnected();
        if (isConnected) {
          WasteFullScreenLoader.stopLoading();
          return;
        }

        // Send Email to reset password
        await AuthenticationRepository.instance.sendPasswordResetEmail(email);

        // Remove loader
        WasteFullScreenLoader.stopLoading();

        // Show Success Screen
        WasteLoaders.successSnackBar(
          title: "Email sent",
          message: "Email Link Sent to Reset Password".tr,
        );
      } catch (e) {
        WasteFullScreenLoader.stopLoading();
        WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
      }
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }
}
