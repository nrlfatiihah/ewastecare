import 'package:ewastecare/screens/create_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/controllers/login_controller.dart';
import 'package:ewastecare/widgets/create_account/input_field.dart';
import 'package:ewastecare/widgets/create_account/password_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    const Color primaryGreen = Color(0xFF9CCC65);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              // --- Header Section ---
              Image.asset(
                'assets/images/ewastecare_logo.png',
                width: 150,
                height: 150,
              ),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Small Actions, Big Impact",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 50),

              // --- Email Fields ---
              InputField(
                label: "Email",
                icon: Icons.email_outlined,
                controller: controller.emailController,
              ),
              const SizedBox(height: 20),

              // --- Password Fields ---
              PasswordField(controller: controller),

              // --- Remember Me & Forgot Password ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (val) => controller.toggleRememberMe(val),
                          activeColor: primaryGreen,
                        ),
                      ),
                      const Text(
                        "Remember Me",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- Sign In Button ---
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // --- Footer ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Get.to(() => const CreateAccountScreen()),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
