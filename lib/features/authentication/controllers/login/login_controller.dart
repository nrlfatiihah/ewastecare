// use and checked
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/admin_navigation_menu.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/features/authentication/screens/signup/admin_signup/admin_verify_email.dart';
import 'package:ewastecare/features/authentication/screens/signup/user_signup/verify_email.dart';
import 'package:ewastecare/user_navigation_menu.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static const _rememberEmailKey = 'USER_REMEMBER_ME_EMAIL';
  static const _rememberPasswordKey = 'USER_REMEMBER_ME_PASSWORD';

  // variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> userLoginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read(_rememberEmailKey) ?? "";
    password.text = localStorage.read(_rememberPasswordKey) ?? "";
    super.onInit();
  }

  // Email and Password Signin
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start loading
      WasteFullScreenLoader.openLoadingDialog(
        WasteTexts.loginLoading.tr,
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
        localStorage.write(_rememberEmailKey, email.text.trim());
        localStorage.write(_rememberPasswordKey, password.text.trim());
      }

      // Login user using Email & Password Auth
      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      final uid = userCredentials.user?.uid ?? '';
      final userRole = await AuthenticationRepository.instance.getUserRole(uid);
      final adminRole = await AdminAuthenticationRepository.instance
          .getAdminRole(uid);
      final isAdminApproved = adminRole == 'admin'
          ? await AdminAuthenticationRepository.instance.isAdminApproved(uid)
          : null;

      // Handle redirection based on role
      redirectToHomePage(
        userRole: userRole,
        adminRole: adminRole,
        isAdminApproved: isAdminApproved,
      );
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  // Check role for user then redirect to dedicated home page
  Future<void> redirectToHomePage({
    required String? userRole,
    required String? adminRole,
    required bool? isAdminApproved,
  }) async {
    final box = GetStorage();
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (user == null) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(
        title: WasteTexts.invalidRoleTitle.tr,
        message: WasteTexts.invalidRoleMessage.tr,
      );
      return;
    }

    if (!user.emailVerified) {
      WasteFullScreenLoader.stopLoading();
      if (adminRole == 'admin') {
        Get.offAll(() => AdminVerifyEmailScreen(email: email));
      } else {
        Get.offAll(() => VerifyEmailScreen(email: email, role: 'user'));
      }
      return;
    }

    if (userRole == 'user') {
      box.remove('admin_logged_in');
      box.write('user_logged_in', true);

      WasteFullScreenLoader.stopLoading();
      Get.offAll(() => const UserNavigationMenu());
      return;
    }

    if (adminRole == 'admin') {
      if (isAdminApproved == true) {
        box.remove('user_logged_in');
        box.write('admin_logged_in', true);

        WasteFullScreenLoader.stopLoading();
        Get.offAll(() => const AdminNavigationMenu());
        return;
      }

      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(
        title: 'Approval required',
        message:
            'Your admin account is pending approval. Please wait until it is approved.',
      );
      return;
    }

    if (userRole == null || userRole.isEmpty) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(
        title: WasteTexts.invalidRoleTitle.tr,
        message: WasteTexts.invalidRoleMessage.tr,
      );
      return;
    }

    WasteFullScreenLoader.stopLoading();
    WasteLoaders.errorSnackBar(
      title: WasteTexts.invalidRoleTitle.tr,
      message: WasteTexts.invalidRoleMessage.tr,
    );
  }

  // Google SignIn Authentication
  Future<void> googleSignIn() async {
    try {
      // start loading animation
      WasteFullScreenLoader.openLoadingDialog(
        WasteTexts.googleLoginLoading.tr,
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
