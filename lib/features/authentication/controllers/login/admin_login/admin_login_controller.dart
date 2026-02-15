// use and checked
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdminLoginController extends GetxController {
  // variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> adminLoginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read("REMEMBER_ME_EMAIL") ?? "";
    password.text = localStorage.read("REMEMBER_ME_PASSWORD") ?? "";
    super.onInit();
  }

  // Email and Password Signin
  Future<void> adminEmailAndPasswordSignIn() async {
    try {
      // Start loading
      WasteFullScreenLoader.openLoadingDialog(
        "Logging you in....",
        WasteImages.docerAnimation,
      );

      //Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!adminLoginFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      // Login user using Email & Password Auth
      final adminCredentials = await AdminAuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // // Check user role after successful login
      final role = await AdminAuthenticationRepository.instance.getAdminRole(
        adminCredentials.user?.uid ?? "",
      );

      final box = GetStorage();
      box.write('admin_logged_in', true);

      redirectToHomePage(role);
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  // Chechk role for admin and user then redirect to dedicated home page
  void redirectToHomePage(String? role) async {
    if (role == "user" || role == null || role.isEmpty) {
      // Handle the case when the role is not found
      WasteFullScreenLoader.stopLoading();
      // Get.offAll(() => const ChooseRole());
      WasteLoaders.errorSnackBar(
        title: "Invalid role",
        message:
            "This account/credential does not have access to this account.",
      );
      return;
    } else if (role == "admin") {
      WasteFullScreenLoader.stopLoading();
      await AdminAuthenticationRepository.instance.adminScreenRedirect();
    } else {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(
        title: "Invalid role",
        message:
            "This account/credential does not have access to this account.",
      );
      return;
    }
  }
}
