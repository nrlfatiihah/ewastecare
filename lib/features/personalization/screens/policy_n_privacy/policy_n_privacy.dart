import 'package:get/get.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class PolicyNPrivacyScreen extends StatelessWidget {
  const PolicyNPrivacyScreen({super.key});

  static const String pdpaPolicyNotice = '''
This Personal Data Protection Notice is issued by eWasteCare in accordance with the Personal Data Protection Act 2010 (Act 709) and the guidance issued by the Personal Data Protection Commissioner of Malaysia (JPDP).

1. Personal data we collect
We may collect personal data including your full name, contact details, address, email address, phone number, account information, service request details, e-waste collection information, payment information, device and usage information, and any other information you voluntarily provide to us.

2. Purpose of collection, use and processing
We collect and process your personal data for the purpose of creating and managing your account, scheduling pickups, providing recycling and related services, processing payments, providing customer support, improving user experience, performing operational and administrative functions, maintaining records, and complying with legal obligations.

3. Consent and notice
We will provide notice at the time of collection and obtain your consent before processing personal data, unless collection or processing is permitted or required by law. By using our services, you acknowledge that you have read and understood this Notice and consent to the collection, use, and processing of your personal data in accordance with this Notice.

4. Disclosure of personal data
Your personal data may be disclosed to authorised service providers, payment processors, partner organisations, professional advisers, and relevant authorities when necessary to deliver our services, manage operations, or comply with legal, contractual, or regulatory obligations. We do not sell or rent your personal data for marketing purposes without your explicit consent.

5. Data security
We will take reasonable steps to protect your personal data against unauthorised access, accidental loss, misuse, alteration, disclosure, or destruction. This includes access controls, secure storage, staff confidentiality obligations, and operational safeguards.

6. Retention
We will retain personal data only for as long as necessary to fulfil the purposes stated in this Notice, or as required by law, contract, or regulatory requirements. When personal data is no longer required, we will securely delete, destroy, or anonymise it in accordance with our internal policies.

7. Transfer of personal data outside Malaysia
If personal data is transferred outside Malaysia, we will ensure that the transfer is lawful, necessary, and subject to appropriate safeguards to protect the personal data from unauthorised access or misuse.

8. Your rights
Under the Personal Data Protection Act 2010, you may request access to your personal data, request correction of any inaccurate or incomplete information, and withdraw your consent to the processing of your personal data, subject to legal and contractual limitations. To exercise your rights, please contact us using the details below.

9. Contact
Email: ecoprojectunimas@gmail.com
Phone: 014-3049034
Address: UNIMAS, Kota Samarahan, Sarawak, Malaysia

We will review your request and respond in accordance with applicable law and the guidance issued by JPDP.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(WasteTexts.policyPrivacy.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(WasteSizes.defaultSpace),
        child: SingleChildScrollView(
          child: SelectableText(
            pdpaPolicyNotice,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
