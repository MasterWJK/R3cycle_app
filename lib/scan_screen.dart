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
          Center(
            child: SizedBox(
              width: 320,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            // 'GestureDetector' widget is used to detect tap events.
                            onTap: () {
                              // This function will be called when the user taps the scan button.
                              // (navigate to the scan screen)
                              // navigate to ScanScreen using cupertinoPageRoute
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 200),
                                  pageBuilder: (_, __, ___) => ScanScreen(),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 1),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOut,
                                      )),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              height: 54, // Sets the height of the button.
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 11.0,
                              ), // Adds padding inside the button.
                              decoration: BoxDecoration(
                                // Provides styling for the button.
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                        27.0)), // Makes the button round.
                                color: Colors.white.withOpacity(0.5),
                                boxShadow: [
                                  // Adds a shadow effect to the button.
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                // Contains a row of widgets (icon and text).
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Centers the row's children on the main axis.
                                children: [
                                  Text(
                                    "Enter code",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            // This function will be called when the user taps the map button.
                            // (navigate to the map screen)
                          },
                          child: Container(
                            height: 54, // Sets the height of the button.
                            width: 80, // Sets the width of the button.
                            decoration: BoxDecoration(
                              // Provides styling for the button.
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                      27.0)), // Makes the button round.
                              color: Colors.white
                                  .withOpacity(0.5), // Sets the button's color.
                              boxShadow: [
                                // Adds a shadow effect to the button.
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.flashlight_on, // Displays a map icon.
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded, // Material back arrow icon
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Go back when the back arrow is pressed
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      // Handle "How it works" button press
                    },
                    child: const Row(
                      children: [
                        Text(
                          'How it works',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(
                            width: 8), // Add spacing between the text and icon
                        Icon(
                          Icons.info_rounded, // Info icon
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
