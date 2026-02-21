import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class PolicyNPrivacyScreen extends StatelessWidget {
  const PolicyNPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: WasteAppBar(showBackArrow: true, title: Text("Policy & Privacy")),
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
                    "Your privacy is important to us. We collect personal data only to improve your eWasteCare experience. Your data will not be shared with third parties without your consent. You can request to delete your account and data anytime",
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
