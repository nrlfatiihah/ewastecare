// use and checked
import 'package:ewastecare/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:ewastecare/features/authentication/screens/login/login_user/login.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WasteSizes.defaultSpace),
          child: Column(
            children: [
              Image(
                image: const AssetImage(WasteImages.deliveredEmailIllustration),
                width: WasteHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: WasteSizes.spaceBtwSections),

              // Title & Subtitle
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              Text(
                WasteTexts.changeYourPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              Text(
                WasteTexts.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              //Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WasteColors.buttonPrimary,
                    side: const BorderSide(color: WasteColors.buttonPrimary),
                  ),
                  onPressed: () => Get.offAll(() => const LoginScreen()),
                  child: const Text(WasteTexts.done),
                ),
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => ForgetPasswordController.instance
                      .resendPasswordResetEmail(email),
                  child: const Text(WasteTexts.resendEmail),
                ),
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),
            ],
          ),
        ),
      ),
    );
  }
}
