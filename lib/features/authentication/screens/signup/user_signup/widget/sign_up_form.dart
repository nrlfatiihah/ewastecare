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
    final isNarrowScreen = MediaQuery.of(context).size.width < 380;
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          // First Name & last name
          if (isNarrowScreen) ...[
            TextFormField(
              controller: controller.firstName,
              validator: (value) => WasteValidator.validateStringAlphabetic(
                WasteTexts.firstNameValidation.tr,
                value,
              ),
              expands: false,
              decoration: InputDecoration(
                labelText: WasteTexts.firstName.tr,
                prefixIcon: Icon(Iconsax.user),
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwInputFields),
            TextFormField(
              controller: controller.lastName,
              validator: (value) => WasteValidator.validateStringAlphabetic(
                WasteTexts.lastNameValidation.tr,
                value,
              ),
              expands: false,
              decoration: InputDecoration(
                labelText: WasteTexts.lastName.tr,
                prefixIcon: Icon(Iconsax.user),
              ),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    validator: (value) =>
                        WasteValidator.validateStringAlphabetic(
                          WasteTexts.firstNameValidation.tr,
                          value,
                        ),
                    expands: false,
                    decoration: InputDecoration(
                      labelText: WasteTexts.firstName.tr,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ),
                const SizedBox(width: WasteSizes.spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>
                        WasteValidator.validateStringAlphabetic(
                          WasteTexts.lastNameValidation.tr,
                          value,
                        ),
                    expands: false,
                    decoration: InputDecoration(
                      labelText: WasteTexts.lastName.tr,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Username
          TextFormField(
            validator: (value) => WasteValidator.validateAlphanumeric(
              WasteTexts.usernameValidation.tr,
              value,
            ),
            controller: controller.username,
            expands: false,
            decoration: InputDecoration(
              labelText: WasteTexts.username.tr,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Address line
          TextFormField(
            validator: (value) => WasteValidator.validateAddress(
              WasteTexts.homeAddressValidation.tr,
              value,
            ),
            controller: controller.homeAddress,
            expands: false,
            decoration: InputDecoration(
              labelText: WasteTexts.homeAddress.tr,
              prefixIcon: Icon(Iconsax.location),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Age & Gender
          if (isNarrowScreen) ...[
            TextFormField(
              controller: controller.age,
              validator: (value) => WasteValidator.validateAge(
                WasteTexts.ageValidation.tr,
                value,
              ),
              expands: false,
              decoration: InputDecoration(
                labelText: WasteTexts.age.tr,
                prefixIcon: Icon(Iconsax.calendar),
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwInputFields),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: controller.gender.value,
              validator: (value) => WasteValidator.validateGender(
                WasteTexts.genderValidation.tr,
                value,
              ),
              onChanged: (String? newValue) {
                controller.gender.value = newValue!;
              },
              items: <String>['Male', 'Female'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value == 'Male' ? WasteTexts.male.tr : WasteTexts.female.tr,
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: WasteTexts.gender.tr,
                prefixIcon: Icon(Iconsax.link),
              ),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.age,
                    validator: (value) => WasteValidator.validateAge(
                      WasteTexts.ageValidation.tr,
                      value,
                    ),
                    expands: false,
                    decoration: InputDecoration(
                      labelText: WasteTexts.age.tr,
                      prefixIcon: Icon(Iconsax.calendar),
                    ),
                  ),
                ),
                const SizedBox(width: WasteSizes.spaceBtwInputFields),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: controller.gender.value,
                    validator: (value) => WasteValidator.validateGender(
                      WasteTexts.genderValidation.tr,
                      value,
                    ),
                    onChanged: (String? newValue) {
                      controller.gender.value = newValue!;
                    },
                    items: <String>['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value == 'Male'
                              ? WasteTexts.male.tr
                              : WasteTexts.female.tr,
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: WasteTexts.gender.tr,
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
              isExpanded: true,
              value: controller.role.value,
              validator: (value) =>
                  value == null ? WasteTexts.selectYourRole.tr : null,
              onChanged: (String? newValue) {
                controller.role.value = newValue;
              },
              items: [
                DropdownMenuItem(
                  value: 'user',
                  child: Text(WasteTexts.userRole.tr),
                ),
                DropdownMenuItem(
                  value: 'admin',
                  child: Text(WasteTexts.adminRole.tr),
                ),
              ],
              decoration: InputDecoration(
                labelText: WasteTexts.role.tr,
                prefixIcon: const Icon(Iconsax.security_user),
              ),
            ),
          ),

          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            controller: controller.phoneNo,
            validator: (value) => WasteValidator.validatePhoneNumber(value),
            expands: false,
            decoration: InputDecoration(
              labelText: WasteTexts.phoneNo.tr,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            controller: controller.email,
            validator: (value) => WasteValidator.validateEmail(value),
            expands: false,
            decoration: InputDecoration(
              labelText: WasteTexts.email.tr,
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
              child: Text(WasteTexts.createAccount.tr),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwSections),
        ],
      ),
    );
  }
}
