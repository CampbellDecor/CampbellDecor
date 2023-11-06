// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: QRGenScreen(),
//     );
//   }
// }
//
// class QRGenScreen extends StatefulWidget {
//   @override
//   _QRGenScreenState createState() => _QRGenScreenState();
// }
//
// class _QRGenScreenState extends State<QRGenScreen> {
//   String pdfData = '';
//
//   @override
//   void initState() {
//     super.initState();
//     // Load the PDF file from assets
//     loadPDFAsset('assets/Sample.pdf').then((pdfBytes) {
//       setState(() {
//         pdfData = encodePdfToBase64(pdfBytes);
//       });
//     });
//   }
//
//   Future<Uint8List> loadPDFAsset(String assetPath) async {
//     final ByteData data = await rootBundle.load(assetPath);
//     return data.buffer.asUint8List();
//   }
//
//   String encodePdfToBase64(Uint8List pdfData) {
//     return base64Encode(pdfData);
//   }
//
//   Future<void> handleQRCodeScan() async {
//     try {
//       ScanResult result = await BarcodeScanner.scan();
//       String scannedData = result.rawContent;
//       // Decode the scanned data
//       Uint8List pdfBytes = base64Decode(scannedData);
//       // Save the PDF file
//       savePdfFile(pdfBytes);
//     } catch (e) {
//       // Handle errors or display a message if the QR code couldn't be scanned or the PDF couldn't be saved.
//     }
//   }
//
//   Future<void> savePdfFile(Uint8List pdfBytes) async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/scanned.pdf');
//       await file.writeAsBytes(pdfBytes);
//     } catch (e) {
//       print('Failed to save PDF: $e');
//     }
//   }
//
//   // Future<void> savePdfFile(Uint8List pdfBytes) async {
//   //   final directory = await getApplicationDocumentsDirectory();
//   //   final file = File('${directory.path}/scanned.pdf');
//   //   await file.writeAsBytes(pdfBytes);
//   //   // You can display a success message or perform further actions here.
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Generator'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             generateQRCode(pdfData),
//             SizedBox(height: 16.0),
//             Text("Scan this QR code to save the embedded PDF"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget generateQRCode(String data) {
//     return QrImageView(
//       data: data,
//       version: QrVersions.auto,
//       size: 200.0,
//     );
//   }
// }
