// use and checked
import 'package:ewastecare/features/authentication/screens/choose_role/widget/choose_role_header.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(WasteSizes.spaceBtwItems),
        child: WelcomeHeader(dark: dark),
      ),
    );
  }
}
