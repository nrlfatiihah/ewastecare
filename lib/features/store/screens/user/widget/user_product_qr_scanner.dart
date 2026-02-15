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
      body: Stack(
        children: [
          // Scanner
          MobileScanner(
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;

              final qrCode = barcodes.first.rawValue;
              if (!_isScanned && qrCode != null) {
                _isScanned = true; // stop multiple triggers
                _navigateToRedeemItemForm(qrCode);
              }
            },
          ),

          // Overlay (like old red border)
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Instruction text
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(child: Text('Scan a code')),
          ),
        ],
      ),
    );
  }

  void _navigateToRedeemItemForm(String qrCode) {
    Get.off(() => RedeemItemForm(), arguments: qrCode);
  }
}
