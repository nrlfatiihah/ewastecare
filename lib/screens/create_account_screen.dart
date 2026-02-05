import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/controllers/create_account_controller.dart';
import 'package:ewastecare/widgets/create_account/input_field.dart';
import 'package:ewastecare/widgets/create_account/dropdown_field.dart';
import 'package:ewastecare/widgets/create_account/password_field.dart';
import 'package:ewastecare/widgets/create_account/checkbox_terms.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAccountController());
    const Color primaryGreen = Color(0xFF9CCC65);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Account",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // First & Last Name
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: "First Name",
                      icon: Icons.person_outline,
                      controller: controller.firstNameController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputField(
                      label: "Last Name",
                      icon: Icons.person_outline,
                      controller: controller.lastNameController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              InputField(
                label: "Username",
                icon: Icons.account_circle_outlined,
                controller: controller.usernameController,
              ),
              const SizedBox(height: 15),

              InputField(
                label: "Address",
                icon: Icons.home_outlined,
                controller: controller.addressController,
              ),
              const SizedBox(height: 15),

              // Age & Gender
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: "Age",
                      icon: Icons.calendar_today_outlined,
                      controller: controller.ageController,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Obx(
                      () => DropdownField(
                        label: "Gender",
                        icon: Icons.person_outline,
                        value: controller.selectedGender.value,
                        items: controller.genderOptions,
                        onChanged: (val) =>
                            controller.selectedGender.value = val,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              InputField(
                label: "Email",
                icon: Icons.email_outlined,
                controller: controller.emailController,
              ),
              const SizedBox(height: 15),

              InputField(
                label: "Phone Number",
                icon: Icons.phone_outlined,
                controller: controller.phoneController,
              ),
              const SizedBox(height: 15),

              DropdownField(
                label: "Role",
                icon: Icons.badge_outlined,
                value: controller.selectedRole.value,
                items: controller.roleOptions,
                onChanged: (val) => controller.selectedRole.value = val,
              ),
              const SizedBox(height: 15),

              PasswordField(controller: controller),
              const SizedBox(height: 15),

              CheckboxTerms(controller: controller),
              const SizedBox(height: 15),

              // Create Account Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveToDatabase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
