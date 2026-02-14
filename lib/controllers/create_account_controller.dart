import 'package:ewastecare/widgets/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/admin/admin_repository.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/data/repositories/user/user_repository.dart';
import 'package:ewastecare/screens/verify_email_screen.dart';
import 'package:ewastecare/models/admin_model.dart';
import 'package:ewastecare/models/user_model.dart';
import 'package:ewastecare/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // variables
  final hidePassword = true.obs; // Observable for hiding/showing password
  final privacyPolicy = true.obs; // Observable for hiding/showing password
  final firstName = TextEditingController(); // controller for first name input
  final lastName = TextEditingController(); // controller for lastname input
  final username = TextEditingController(); // controller for username input
  final homeAddress = TextEditingController(); // controller for address input
  final gender = Rx<String?>(null); // controller for gender input
  final age = TextEditingController(); // controller for age input
  final email = TextEditingController(); // controller for email input
  final phoneNo = TextEditingController(); // controller for phone number input
  final password = TextEditingController(); // controller for password input
  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); // Form key for form validation

  // SIGNUP CONTROLLER FUNCTION FOR USER
  void signup() async {
    try {
      // Start loading
      WasteFullScreenLoader.openLoadingDialog(
        "We are processing your information...",
        BakoImages.docerAnimation,
      );

      // Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        BakoFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!signupFormKey.currentState!.validate()) {
        // Remove loader
        BakoFullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        BakoFullScreenLoader.stopLoading();
        BakoLoaders.warningSnackBar(
          title: "Accept Privacy Policy",
          message:
              "In order to create account, you must have to read and accept the Privacy Policy and Terms of Use.",
        );
        return;
      }

      // Register user in the Firebase Aurhentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
            email.text.trim(),
            password.text.trim(),
          );

      // Save Authenticated user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        homeAddress: homeAddress.text.trim(),
        gender: gender.value?.trim() ?? "",
        age: age.text.trim(),
        email: email.text.trim(),
        phoneNo: phoneNo.text.trim(),
        profilePicture: "",
        ecoPoint: 0,
        role: "user",
        userQR: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      BakoFullScreenLoader.stopLoading();

      // Show Success Message
      BakoLoaders.successSnackBar(
        title: "Success",
        message:
            "Your account has been created successfully! Verify email to continue",
      );

      // Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      // Remove loader
      BakoFullScreenLoader.stopLoading();
      // Show some generic error message to the user
      BakoLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  // SIGNUP CONTROLLER FUNCTION FOR ADMIN
  void adminSignup() async {
    try {
      // Start loading
      BakoFullScreenLoader.openLoadingDialog(
        "We are processing your information...",
        BakoImages.docerAnimation,
      );

      // Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        BakoFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!signupFormKey.currentState!.validate()) {
        // Remove loader
        BakoFullScreenLoader.stopLoading();
        return;
      }

      // Register admin in the Firebase Aurhentication & Save admin data in the Firebase
      final userCredential = await AdminAuthenticationRepository.instance
          .registerWithEmailAndPassword(
            email.text.trim(),
            password.text.trim(),
          );

      // Save Authenticated user data in the Firebase Firestore
      final newAdmin = AdminModel(
        id: userCredential.user!.uid,
        email: email.text.trim(),
        username: username.text.trim(),
        profilePicture: "",
        role: "admin",
      );

      final userRepository = Get.put(AdminRepository());
      await userRepository.saveAdminRecord(newAdmin);

      BakoFullScreenLoader.stopLoading();

      // Show Success Message
      BakoLoaders.successSnackBar(
        title: "Success",
        message:
            "Your account has been created successfully! Verify email to continue",
      );

      // Move to Verify Email Screen
      Get.to(() => AdminVerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      // Remove loader
      BakoFullScreenLoader.stopLoading();
      // Show some generic error message to the user
      BakoLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }
}
