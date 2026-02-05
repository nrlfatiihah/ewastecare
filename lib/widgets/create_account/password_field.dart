import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordField extends StatelessWidget {
  final dynamic controller;

  const PasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // This local observable handles the eye-icon toggle
    final obscure = true.obs;

    return Obx(
      () => TextFormField(
        // This will now work for both Login and CreateAccount controllers
        controller: controller.passwordController,
        obscureText: obscure.value,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline),
          labelText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: Icon(obscure.value ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              obscure.value = !obscure.value;
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          } else if (value.length < 6) {
            return 'Password must be at least 6 characters long';
          } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
            return 'Password must contain at least one uppercase letter';
          } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
            return 'Password must contain at least one number';
          }
          return null;
        },
      ),
    );
  }
}
