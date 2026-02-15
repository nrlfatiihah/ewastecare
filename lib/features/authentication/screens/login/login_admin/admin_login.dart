// use and checked
import 'package:ewastecare/common/styles/spacing_styles.dart';
import 'package:ewastecare/features/authentication/screens/login/login_admin/widget/admin_login_form.dart';
import 'package:ewastecare/features/authentication/screens/login/login_admin/widget/admin_login_header.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

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
              AdminLoginHeader(dark: dark),

              /// Form
              const AdminLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
