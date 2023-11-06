import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGen extends StatefulWidget {
  @override
  _PdfGenState createState() => _PdfGenState();
}

class _PdfGenState extends State<PdfGen> {
  Future<List<DocumentSnapshot>> fetchData() async {
    final collection = FirebaseFirestore.instance.collection('events');
    final querySnapshot = await collection.get();
    return querySnapshot.docs;
  }

  Future<Uint8List> generatePDF() async {
    final pdf = pw.Document();
    final data = await fetchData();

    for (var document in data) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(document['name']),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase & PDF Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final pdfBytes = await generatePDF();
              },
              child: Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
