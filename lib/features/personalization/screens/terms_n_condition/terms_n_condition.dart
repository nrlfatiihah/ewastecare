import 'package:get/get.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TermsNConditionScreen extends StatelessWidget {
  const TermsNConditionScreen({super.key});

  static const String pdpaTermsNotice = '''
These Terms and Conditions govern your use of the eWasteCare application, website, and related services. By creating an account or using our services, you agree to be bound by these Terms and Conditions and the Personal Data Protection Notice.

1. Service use
You agree to use eWasteCare responsibly and only for legitimate e-waste collection, recycling, pickup, and related environmental service purposes. You must provide accurate, current, and complete information when registering or using our services.

2. Account responsibility
You are responsible for maintaining the confidentiality of your account credentials. You agree to notify us immediately if you suspect unauthorised use of your account. We may suspend or terminate access to the service where misuse, fraud, or false reporting is detected.

3. Personal data
You agree that eWasteCare may collect, use, and process your personal data in accordance with the Personal Data Protection Act 2010 (Act 709), this Notice, and any applicable guidance issued by JPDP. This includes personal data needed to manage your account, process transactions, deliver services, and communicate with you.

4. Service information and accuracy
You agree that the information you provide, including your address, pickup details, and item descriptions, must be accurate and truthful. We may rely on this information to schedule services and manage environmental processing.

5. Product and service limitations
eWasteCare provides service information and operational support based on the information available to us. We do not guarantee uninterrupted service, error-free operations, or specific outcomes beyond the services expressly stated.

6. Updates and changes
We reserve the right to update or modify these Terms and Conditions and the Personal Data Protection Notice from time to time. Continued use of the application or services after such changes constitutes your acceptance of the updated terms.

7. Liability and compliance
We will act reasonably in the operation of the service and compliance with applicable laws. However, eWasteCare shall not be liable for loss, damage, or disruption caused by misuse of the service, inaccurate information provided by a user, force majeure events, or circumstances beyond our reasonable control.

8. Contact
If you have questions about these Terms and Conditions or the Personal Data Protection Notice, please contact us at ecoprojectunimas@gmail.com or 014-3049034.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(WasteTexts.termsConditions.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(WasteSizes.defaultSpace),
        child: SingleChildScrollView(
          child: SelectableText(
            pdpaTermsNotice,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
