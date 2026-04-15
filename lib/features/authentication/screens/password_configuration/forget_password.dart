// use and checked
import 'package:ewastecare/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(WasteSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              WasteTexts.forgetPassword.tr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: WasteSizes.spaceBtwItems),

            Text(
              WasteTexts.forgetPasswordSubTitle.tr,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections * 2),

            //Text Fields
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: WasteValidator.validateEmail,
                decoration: InputDecoration(
                  labelText: WasteTexts.email.tr,
                  prefixIcon: Icon(Iconsax.direct_right),
                ),
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections),

            //Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: WasteColors.buttonPrimary,
                  side: const BorderSide(color: WasteColors.buttonPrimary),
                ),
                onPressed: () => controller.sendPasswordResetEmail(),
                child: Text(WasteTexts.submit.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
