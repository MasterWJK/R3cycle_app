import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color of the scaffold
      body: Stack(
        children: [
          // QR scanner content
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          // Positioned.fill(
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: Container(
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          Positioned.fill(
            child: Container(
              color: Color(0xFF1C292D).withOpacity(0.6),
              child: CustomPaint(
                painter: CutoutPainter(),
              ),
            ),
          ),
          // AppBar stacked on top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              // Add any desired AppBar content, such as title or actions
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _processQRCode(scanData.code!);
      });
    });
  }

  void _processQRCode(String code) {
    // Handle the scanned QR code data here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code Scanned'),
          content: Text(code),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CutoutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final qrCodeWidth = 320.0; // Adjust the width of the QR code cutout
    final qrCodeHeight = 320.0; // Adjust the height of the QR code cutout
    final rradius = 20.0; // Adjust the corner radius of the QR code cutout

    final rect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(width / 2, height / 2),
        width: qrCodeWidth,
        height: qrCodeHeight,
      ),
      topLeft: Radius.circular(rradius),
      topRight: Radius.circular(rradius),
      bottomLeft: Radius.circular(rradius),
      bottomRight: Radius.circular(rradius),
    );

    final path = Path()..addRRect(rect);

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white // Set the cutout color
        ..blendMode = BlendMode.clear, // Use xor blend mode for the cutout
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
