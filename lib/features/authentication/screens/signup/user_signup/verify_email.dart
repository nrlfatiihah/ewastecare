// use and checked
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email, required this.role});

  final String? email;
  final String role;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController(role));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => AuthenticationRepository.instance.logout(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WasteSizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage(WasteImages.deliveredEmailIllustration),
                width: WasteHelperFunctions.screenWidth() * 1.0,
                height: WasteHelperFunctions.screenHeight() * 0.3,
              ),
              const SizedBox(height: WasteSizes.spaceBtwSections),

              // Title & Subtitle
              Text(
                WasteTexts.confirmEmail.tr,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              Text(
                email ?? "",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              Text(
                WasteTexts.confirmEmailSubTitle.tr,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.checkEmailVerificationStatus(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WasteColors.buttonPrimary,
                  ),
                  child: Text(WasteTexts.tContinue.tr),
                ),
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => controller.sendEmailVerification(),
                  child: Text(WasteTexts.resendEmail.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
