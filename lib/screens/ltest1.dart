// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
//
// import '../reusable/reusable_methods.dart';
//
// class TestDelete extends StatelessWidget {
//   const TestDelete({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _createPDF();
//           },
//           child: Text("Create PDF"),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _createPDF() async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Center(
//           child: pw.Text('Hello World!'),
//         ),
//       ),
//     );
//     final directory = await getApplicationDocumentsDirectory();
//     final path = '${directory.path}/example.pdf';
//     print(path);
//     final File file = File(path);
//     await file.writeAsBytes(await pdf.save());
//     savePdfForFirebase(file, 'X9FIhVXSkTbsVrY8I6vO');
//   }
// }
