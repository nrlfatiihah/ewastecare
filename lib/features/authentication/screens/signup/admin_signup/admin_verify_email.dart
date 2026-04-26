import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/features/authentication/controllers/signup/admin_verify_email_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminVerifyEmailScreen extends StatelessWidget {
  const AdminVerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminVerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => AdminAuthenticationRepository.instance.logout(),
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
                width: WasteHelperFunctions.screenWidth() * 0.6,
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
