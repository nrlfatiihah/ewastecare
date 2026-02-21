import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TermsNConditionScreen extends StatelessWidget {
  const TermsNConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text("Terms and Conditions"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //-- details
            Padding(
              padding: EdgeInsets.only(
                right: WasteSizes.defaultSpace,
                left: WasteSizes.defaultSpace,
                bottom: WasteSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  // Title, price, stock
                  SizedBox(height: WasteSizes.spaceBtwItems / 2),
                  Text(
                    "By using eWasteCare, you agree to follow all local e-waste recycling rules and use the app responsibly. You must provide accurate information when creating an account. Your account may be suspended if any misuse or false reporting is detected. eWasteCare reserves the right to update these terms at any time.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: WasteSizes.spaceBtwItems),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
