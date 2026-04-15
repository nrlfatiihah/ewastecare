// use and checked
import 'package:ewastecare/features/authentication/screens/signup/user_signup/widget/sign_up_form.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WasteSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                WasteTexts.signupTitle.tr,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: WasteSizes.spaceBtwSections),

              //Form
              const WasteSignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}
