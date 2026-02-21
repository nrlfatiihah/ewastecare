// use and checked
import 'dart:async';
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/common/widget/success_screen/success_screen.dart';
import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AdminVerifyEmailController extends GetxController {
  static AdminVerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAuthRedirect();
    super.onInit();
  }

  // Send email verification link to user
  sendEmailVerification() async {
    try {
      await AdminAuthenticationRepository.instance.sendEmailVerification();
      WasteLoaders.successSnackBar(
        title: "Email Sent",
        message: "Please Check your inbox and verify your email",
      );
    } catch (e) {
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  // Timer to auto redirect on email verification
  setTimerForAuthRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(
          () => SuccessScreen(
            image: WasteImages.successfullyRegisterAnimation,
            title: WasteTexts.yourAccountCreatedTitle,
            subTitle: WasteTexts.yourAccountCreatedSubTitle,
            onPressed: () =>
                AdminAuthenticationRepository.instance.adminScreenRedirect(),
          ),
        );
      }
    });
  }

  // normally check if email verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          image: WasteImages.successfullyRegisterAnimation,
          title: WasteTexts.yourAccountCreatedTitle,
          subTitle: WasteTexts.yourAccountCreatedSubTitle,
          onPressed: () =>
              AdminAuthenticationRepository.instance.adminScreenRedirect(),
        ),
      );
    }
  }
}
