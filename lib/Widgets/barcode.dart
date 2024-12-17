import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          if (capture.raw != null) {
            final List<Barcode> barcodes = capture.barcodes;
            for (var barcode in barcodes) {
              print(barcode);
            }
          }
        },
      ),
    );
  }
}
