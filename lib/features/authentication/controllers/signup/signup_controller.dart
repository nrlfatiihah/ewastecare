// use and checked
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/admin/admin_repository.dart';
import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/data/repositories/user/user_repository.dart';
import 'package:ewastecare/features/authentication/screens/signup/admin_signup/admin_verify_email.dart';
import 'package:ewastecare/features/authentication/screens/signup/user_signup/verify_email.dart';
import 'package:ewastecare/features/personalization/models/admin_modal.dart';
import 'package:ewastecare/features/personalization/models/user_model.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // variables
  final hidePassword = true.obs; // Observable for hiding/showing password
  final privacyPolicy = true.obs; // Observable for hiding/showing password
  final firstName = TextEditingController(); // controller for first name input
  final lastName = TextEditingController(); // controller for last name input
  final username = TextEditingController(); // controller for username input
  final homeAddress = TextEditingController(); // controller for address input
  final gender = Rx<String?>(null); // controller for gender input
  final age = TextEditingController(); // controller for age input
  final role = Rx<String?>(null); // controller for role input
  final email = TextEditingController(); // controller for email input
  final phoneNo = TextEditingController(); // controller for phone number input
  final password = TextEditingController(); // controller for password input
  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); // Form key for form validation

  void signup() async {
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
        return;
      }

      // Form validation
      if (!signupFormKey.currentState!.validate()) {
        // Remove loader
        WasteFullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        WasteFullScreenLoader.stopLoading();
        WasteLoaders.warningSnackBar(
          title: "Accept Privacy Policy",
          message:
              "In order to create account, you must have to read and accept the Privacy Policy and Terms of Use.",
        );
        return;
      }

      // User Registration
      if (role.value == "user") {
        // Register user in the Firebase Authentication & Save user data in the Firebase
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
          wastePoint: 0,
          role: "user",
          userQR: '',
        );

        final userRepository = Get.put(UserRepository());
        await userRepository.saveUserRecord(newUser);

        WasteFullScreenLoader.stopLoading();

        // Show Success Message
        WasteLoaders.successSnackBar(
          title: "Success",
          message:
              "Your account has been created successfully! Verify email to continue",
        );

        // Move to Verify Email Screen
        Get.to(
          () => VerifyEmailScreen(email: email.text.trim(), role: role.value!),
        );
      } else if (role.value == "admin") {
        // Register admin in the Firebase Authentication & Save admin data in the Firebase
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

        WasteFullScreenLoader.stopLoading();

        // Show Success Message
        WasteLoaders.successSnackBar(
          title: "Success",
          message:
              "Your account has been created successfully! Verify email to continue",
        );

        // Move to Verify Email Screen
        Get.to(
          () => VerifyEmailScreen(email: email.text.trim(), role: role.value!),
        );
      }
    } catch (e) {
      // Remove loader
      WasteFullScreenLoader.stopLoading();
      // Show some generic error message to the user
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }
}
