import 'package:ewastecare/features/store/screens/user/widget/user_redeem_item_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class UserProductQRScanner extends StatefulWidget {
  const UserProductQRScanner({Key? key}) : super(key: key);

  @override
  UserProductQRScannerState createState() => UserProductQRScannerState();
}

class UserProductQRScannerState extends State<UserProductQRScanner> {
  bool _isScanned = false; // prevent multiple navigations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              onDetect: (capture) {
                final barcodes = capture.barcodes;
                if (barcodes.isEmpty) return;

                final qrCode = barcodes.first.rawValue;
                if (!_isScanned && qrCode != null && qrCode.isNotEmpty) {
                  _isScanned = true; // stop multiple triggers
                  // Navigate to RedeemItemForm safely
                  Get.to(() => const RedeemItemForm(), arguments: qrCode);
                }
              },
            ),
          ),
          // Instruction text
          const Expanded(flex: 1, child: Center(child: Text('Scan a code'))),
        ],
      ),
    );
  }
}
