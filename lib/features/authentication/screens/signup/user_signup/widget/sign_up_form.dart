// use and checked
import 'package:ewastecare/common/widget/form_fields/address_autocomplete_field.dart';
import 'package:ewastecare/features/authentication/controllers/signup/signup_controller.dart';
import 'package:ewastecare/features/authentication/screens/signup/user_signup/widget/terms_conditions_checkbox.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class WasteSignUpForm extends StatelessWidget {
  const WasteSignUpForm({super.key});

  Widget _buildPasswordRequirement(
    BuildContext context, {
    required bool met,
    required String text,
  }) {
    final textTheme = Theme.of(context).textTheme.bodySmall;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          met ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: met ? WasteColors.success : WasteColors.darkGrey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: textTheme?.copyWith(
              color: met ? WasteColors.success : WasteColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

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
          WasteAddressAutocompleteField(
            controller: controller.homeAddress,
            validator: (value) => WasteValidator.validateAddress(
              WasteTexts.homeAddressValidation.tr,
              value,
            ),
            labelText: WasteTexts.homeAddress.tr,
            prefixIcon: const Icon(Iconsax.location),
          ),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),

          // Date of Birth & Gender
          if (isNarrowScreen) ...[
            TextFormField(
              controller: controller.dateOfBirthController,
              readOnly: true,
              validator: (value) => WasteValidator.validateDateOfBirth(value),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate:
                      controller.selectedDateOfBirth.value ??
                      DateTime.now().subtract(Duration(days: 365 * 18)),
                  firstDate: DateTime(1924),
                  lastDate: DateTime.now().subtract(Duration(days: 365 * 7)),
                );
                if (picked != null) {
                  controller.selectedDateOfBirth.value = picked;
                  controller.dateOfBirthController.text = DateFormat(
                    'yyyy-MM-dd',
                  ).format(picked);
                }
              },
              expands: false,
              decoration: InputDecoration(
                labelText: WasteTexts.dateOfBirth.tr,
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
                    controller: controller.dateOfBirthController,
                    readOnly: true,
                    validator: (value) =>
                        WasteValidator.validateDateOfBirth(value),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            controller.selectedDateOfBirth.value ??
                            DateTime.now().subtract(Duration(days: 365 * 18)),
                        firstDate: DateTime(1924),
                        lastDate: DateTime.now().subtract(
                          Duration(days: 365 * 7),
                        ),
                      );
                      if (picked != null) {
                        controller.selectedDateOfBirth.value = picked;
                        controller.dateOfBirthController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(picked);
                      }
                    },
                    expands: false,
                    decoration: InputDecoration(
                      labelText: WasteTexts.dateOfBirth.tr,
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
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.password,
            builder: (context, passwordValue, _) {
              final passwordText = passwordValue.text;
              final hasMinLength = passwordText.length >= 6;
              final hasUppercase = passwordText.contains(RegExp(r'[A-Z]'));
              final hasNumber = passwordText.contains(RegExp(r'[0-9]'));
              final hasSpecialCharacter = passwordText.contains(
                RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
              );

              return Column(
                children: [
                  Obx(
                    () => TextFormField(
                      controller: controller.password,
                      validator: (value) =>
                          WasteValidator.validatePassword(value),
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
                  const SizedBox(height: 8),
                  _buildPasswordRequirement(
                    context,
                    met: hasMinLength,
                    text: WasteTexts.passwordMinLength.tr,
                  ),
                  const SizedBox(height: 4),
                  _buildPasswordRequirement(
                    context,
                    met: hasUppercase,
                    text: WasteTexts.passwordUppercase.tr,
                  ),
                  const SizedBox(height: 4),
                  _buildPasswordRequirement(
                    context,
                    met: hasNumber,
                    text: WasteTexts.passwordNumber.tr,
                  ),
                  const SizedBox(height: 4),
                  _buildPasswordRequirement(
                    context,
                    met: hasSpecialCharacter,
                    text:
                        '${WasteTexts.passwordSpecialChar.tr} (e.g. !, @, #, \$)',
                  ),
                ],
              );
            },
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
