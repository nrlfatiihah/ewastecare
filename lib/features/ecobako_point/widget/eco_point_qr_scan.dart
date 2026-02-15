import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  QRScannerScreenState createState() => QRScannerScreenState();
}

class QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanned = false; // prevent multiple scans

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
                if (!_isScanned && qrCode != null) {
                  _isScanned = true; // prevent multiple triggers
                  Get.back(result: qrCode);
                }
              },
            ),
          ),
          const Expanded(flex: 1, child: Center(child: Text('Scan a code'))),
        ],
      ),
    );
  }
}
