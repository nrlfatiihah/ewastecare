// use and checked
import 'package:ewastecare/common/styles/spacing_styles.dart';
import 'package:ewastecare/features/authentication/screens/login/login_user/widget/login_form.dart';
import 'package:ewastecare/features/authentication/screens/login/login_user/widget/login_header.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: WasteSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title, subtitle
              WasteLoginHeader(dark: dark),

              /// Form
              const WasteLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
