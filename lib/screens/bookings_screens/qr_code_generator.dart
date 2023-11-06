import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenScreen extends StatelessWidget {
  final String qrData = "Hello Pinthu";

  Widget generateQRCode(String data) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: 200.0,
    );
  }

  // Widget generateQRCode(Map<String, dynamic> data) {
  //   Fluttertoast.showToast(
  //       msg: data['name'],
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.white,
  //       textColor: Colors.black);
  //   return QrImageView(
  //     data: data['name'],
  //     version: QrVersions.auto,
  //     size: 200.0,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            generateQRCode(qrData),
            SizedBox(height: 16.0),
            Text("Scan this QR code"),
          ],
        ),
      ),
    );
  }
}
