import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/screens/admin/admin_homepage.dart';
import 'package:ewastecare/screens/user/user_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscureText = true.obs;

  // State Observables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Check if Email is Verified
        if (!user.emailVerified) {
          isLoading.value = false;
          Get.snackbar(
            "Verify Email",
            "Please verify your email before logging in.",
            backgroundColor: Colors.orangeAccent,
            colorText: Colors.white,
          );
          return;
        }

        // Fetch Role and Redirect
        await _fetchUserRoleAndRedirect(user.uid);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        "Invalid credentials: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchUserRoleAndRedirect(String uid) async {
    // Check 'users' collection first
    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      Get.offAll(() => const UserHomePage());
      return;
    }

    // If not in 'users', check 'admins' collection
    DocumentSnapshot adminDoc = await _firestore
        .collection('admins')
        .doc(uid)
        .get();

    if (adminDoc.exists) {
      // It's an admin
      Get.offAll(() => const AdminHomePage());
      return;
    }

    // If UID is found in Auth but not in either collection
    Get.snackbar(
      "Error",
      "User record not found in database.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
