// CAN BE DELETED

// import 'package:ewastecare/common/widget/loaders/loaders.dart';
// import 'package:ewastecare/data/repositories/admin/admin_repository.dart';
// import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
// import 'package:ewastecare/features/authentication/screens/signup/admin_signup/admin_verify_email.dart';
// import 'package:ewastecare/features/personalization/models/admin_modal.dart';
// import 'package:ewastecare/utils/constants/image_strings.dart';
// import 'package:ewastecare/utils/helpers/network_manager.dart';
// import 'package:ewastecare/utils/popups/full_screen_loader.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AdminSignupController extends GetxController {
//   static AdminSignupController get instance => Get.find();

//   // variables
//   final hidePassword = true.obs; // Observable for hiding/showing password
//   final email = TextEditingController(); // controller for email input
//   final password = TextEditingController(); // controller for password input
//   final username = TextEditingController();
//   GlobalKey<FormState> adminSignupFormKey =
//       GlobalKey<FormState>(); // Form key for form validation

//   void adminSignup() async {
//     try {
//       // Start loading
//       WasteFullScreenLoader.openLoadingDialog(
//           "We are processing your information...", WasteImages.docerAnimation);

//       // Check Internet connectivity
//       final isConnected = await NetworkManager.instance.isConnected();
//       if (!isConnected) {
//         WasteFullScreenLoader.stopLoading();
//         return;
//       }

//       // Form validation
//       if (!adminSignupFormKey.currentState!.validate()) {
//         // Remove loader
//         WasteFullScreenLoader.stopLoading();
//         return;
//       }

//       // Register user in the Firebase Aurhentication & Save user data in the Firebase
//       final userCredential = await AdminAuthenticationRepository.instance
//           .registerWithEmailAndPassword(
//               email.text.trim(), password.text.trim());

//       // Save Authenticated user data in the Firebase Firestore
//       final newAdmin = AdminModel(
//         id: userCredential.user!.uid,
//         email: email.text.trim(),
//         username: username.text.trim(),
//         profilePicture: "",
//         role: "admin",
//       );

//       final userRepository = Get.put(AdminRepository());
//       await userRepository.saveAdminRecord(newAdmin);

//       WasteFullScreenLoader.stopLoading();

//       // Show Success Message
//       WasteLoaders.successSnackBar(
//           title: "Congratulations",
//           message:
//               "Your account has been created successfully! Verify email to continue");

//       // Move to Verify Email Screen
//       Get.to(() => AdminVerifyEmailScreen(email: email.text.trim()));
//     } catch (e) {
//       // Remove loader
//       WasteFullScreenLoader.stopLoading();
//       // Show some generic error message to the user
//       WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
//     }
//   }
// }
