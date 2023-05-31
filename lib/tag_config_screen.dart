import 'package:flutter/material.dart';

class TagConfigScreen extends StatelessWidget {
  final String qrCode;

  const TagConfigScreen({Key? key, required this.qrCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Configuration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scanned QR Code:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              qrCode,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Perform any action or navigation here
              },
              child: Text('Configure Tag'),
            ),
          ],
        ),
      ),
    );
  }
}
