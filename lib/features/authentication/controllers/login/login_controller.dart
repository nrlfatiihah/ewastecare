// use and checked
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  // variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> userLoginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read("REMEMBER_ME_EMAIL") ?? "";
    password.text = localStorage.read("REMEMBER_ME_PASSWORD") ?? "";
    super.onInit();
  }

  // Email and Password Signin
  Future<void> emailAndPasswordSignIn() async {
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
      if (!userLoginFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      //Save login cridential if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write("REMEMBER_ME_EMAIL", email.text.trim());
        localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
      }

      // Login user using Email & Password Auth
      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // // Check user role after successful login
      final role = await AuthenticationRepository.instance.getUserRole(
        userCredentials.user?.uid ?? "",
      );

      final box = GetStorage();
      box.write('user_logged_in', true);

      // Handle redirection based on role
      redirectToHomePage(role);
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  // Chechk role for user then redirect to dedicated home page
  void redirectToHomePage(String? role) async {
    if (role == "admin" || role == null || role.isEmpty) {
      // Handle the case when the role is not found
      WasteFullScreenLoader.stopLoading();
      // Get.offAll(() => const ChooseRole());
      WasteLoaders.errorSnackBar(
        title: "Invalid role",
        message:
            "This account/credential does not have access to this account.",
      );
      return;
    } else if (role == "user") {
      WasteFullScreenLoader.stopLoading();
      await AuthenticationRepository.instance.userScreenRedirect();
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

  // Google SignIn Authentication
  Future<void> googleSignIn() async {
    try {
      // start loading animation
      WasteFullScreenLoader.openLoadingDialog(
        "Logging you in...",
        WasteImages.docerAnimation,
      );

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        WasteFullScreenLoader.stopLoading();
        return;
      }
    } catch (e) {
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }
}
