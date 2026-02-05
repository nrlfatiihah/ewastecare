import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/screens/verify_email_screen.dart';

class CreateAccountController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Observables
  var selectedGender = RxnString();
  var selectedRole = RxnString();
  var isChecked = false.obs;
  var isLoading = false.obs;

  final genderOptions = ['Male', 'Female'];
  final roleOptions = ['Admin', 'User'];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    addressController.dispose();
    ageController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> saveToDatabase() async {
    // Validation Checks
    if (!formKey.currentState!.validate()) return;

    if (selectedRole.value == null || selectedGender.value == null) {
      Get.snackbar(
        'Error',
        'Please select Gender and Role',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!isChecked.value) {
      Get.snackbar(
        'Error',
        'Please accept the terms and conditions.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Create Auth User
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      User? user = userCredential.user;
      if (user == null) throw Exception("User creation failed.");

      String collectionName = selectedRole.value == 'Admin'
          ? 'admins'
          : 'users';

      // Store in Firestore
      await _firestore.collection(collectionName).doc(user.uid).set({
        'uid': user.uid,
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'username': usernameController.text.trim(),
        'address': addressController.text.trim(),
        'age':
            int.tryParse(ageController.text.trim()) ??
            0, // Store age as a number
        'gender': selectedGender.value,
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'role': selectedRole.value,
        'created_at': FieldValue.serverTimestamp(),
        'isVerified': false,
      });

      // Verification Email
      await user.sendEmailVerification();

      Get.off(() => const VerifyEmailScreen());

      Get.snackbar(
        'Success',
        'Verification email sent!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFields();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Auth Error',
        e.message ?? "Authentication failed",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Database error: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    usernameController.clear();
    addressController.clear();
    ageController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    selectedGender.value = null;
    selectedRole.value = null;
    isChecked.value = false;
  }
}
