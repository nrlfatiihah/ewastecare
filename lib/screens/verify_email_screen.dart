import 'dart:async';
import 'package:ewastecare/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  late User user;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    isEmailVerified = user.emailVerified;

    if (!isEmailVerified) {
      timer = Timer.periodic(const Duration(seconds: 5), (_) {
        checkEmailVerified();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> resendVerificationEmail() async {
    if (!canResendEmail) return;

    try {
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);

      Get.snackbar(
        'Email Sent',
        'Verification link sent to ${user.email}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      await Future.delayed(const Duration(seconds: 60));
      if (mounted) setState(() => canResendEmail = true);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Too many requests. Try later.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> checkEmailVerified() async {
    await user.reload();
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.emailVerified) {
      setState(() => isEmailVerified = true);
      timer?.cancel();

      Get.snackbar(
        'Email Verified',
        'Your email has been verified!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF9CCC65);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isEmailVerified
              ? const Text(
                  'Your email is verified!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 100,
                      color: primaryGreen,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'A verification link has been sent to ${user.email}. '
                      'Please check your inbox/spam.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: canResendEmail
                          ? resendVerificationEmail
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                      ),
                      child: const Text('Resend Email'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
