// use and checked
import 'package:ewastecare/features/authentication/controllers/signup/signup_controller.dart';
import 'package:ewastecare/features/authentication/screens/signup/user_signup/widget/terms_conditions_checkbox.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class WasteSignUpForm extends StatelessWidget {
  const WasteSignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          // First Name & last name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => WasteValidator.validateStringAlphabetic(
                    "First name",
                    value,
                  ),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: WasteTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: WasteSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) => WasteValidator.validateStringAlphabetic(
                    "Last name",
                    value,
                  ),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: WasteTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Username
          TextFormField(
            validator: (value) =>
                WasteValidator.validateAlphanumeric("Username", value),
            controller: controller.username,
            expands: false,
            decoration: const InputDecoration(
              labelText: WasteTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Address line
          TextFormField(
            validator: (value) =>
                WasteValidator.validateAddress("Home address", value),
            controller: controller.homeAddress,
            expands: false,
            decoration: const InputDecoration(
              labelText: WasteTexts.homeAddress,
              prefixIcon: Icon(Iconsax.location),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Age & Gender
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.age,
                  validator: (value) =>
                      WasteValidator.validateAge("Age", value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: WasteTexts.age,
                    prefixIcon: Icon(Iconsax.calendar),
                  ),
                ),
              ),
              const SizedBox(width: WasteSizes.spaceBtwInputFields),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.gender.value,
                  validator: (value) =>
                      WasteValidator.validateGender("Gender", value),
                  onChanged: (String? newValue) {
                    controller.gender.value = newValue!;
                  },
                  items: <String>['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: WasteTexts.gender,
                    prefixIcon: Icon(Iconsax.link),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Role
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.role.value,
              validator: (value) => value == null ? 'Select your role' : null,
              onChanged: (String? newValue) {
                controller.role.value = newValue;
              },
              items: const [
                DropdownMenuItem(value: 'user', child: Text('User')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              decoration: const InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Iconsax.security_user),
              ),
            ),
          ),

          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            controller: controller.phoneNo,
            validator: (value) => WasteValidator.validatePhoneNumber(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: WasteTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            controller: controller.email,
            validator: (value) => WasteValidator.validateEmail(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: WasteTexts.email,
              prefixIcon: Icon(Iconsax.direct),
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
                labelText: WasteTexts.password,
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
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          //Terms and Conditions Checkbox
          const WasteTermsAndConditionCheckbox(),

          const SizedBox(height: WasteSizes.spaceBtwSections),

          // Sign up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              style: ElevatedButton.styleFrom(
                backgroundColor: WasteColors.buttonPrimary,
                side: const BorderSide(color: WasteColors.buttonPrimary),
              ),
              child: const Text(WasteTexts.createAccount),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwSections),
        ],
      ),
    );
  }
}
