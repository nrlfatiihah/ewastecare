// use and checked
import 'package:ewastecare/features/authentication/controllers/login/admin_login/admin_login_controller.dart';
import 'package:ewastecare/features/authentication/screens/signup/user_signup/signup.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminLoginForm extends StatelessWidget {
  const AdminLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminLoginController());
    return Form(
      key: controller.adminLoginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: WasteSizes.spaceBtwSections,
        ),
        child: Column(
          children: [
            //Email
            TextFormField(
              controller: controller.email,
              validator: (value) => WasteValidator.validateEmail(value),
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: WasteTexts.adminEmail.tr,
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwInputFields),

            //Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => WasteValidator.validatePassword(value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: WasteTexts.password.tr,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections),

            // Sign in Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.adminEmailAndPasswordSignIn(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WasteColors.buttonPrimary,
                  side: const BorderSide(color: WasteColors.buttonPrimary),
                ),
                child: Text(WasteTexts.signIn.tr),
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwItems),

            const SizedBox(height: WasteSizes.spaceBtwItems),

            // Create Account Text
            Center(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: WasteTexts.dontHaveAccount.tr,
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: WasteTexts.createAccount.tr,
                      style: const TextStyle(
                        color: WasteColors.buttonPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.to(() => const SignupScreen()),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}
