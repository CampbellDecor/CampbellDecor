import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campbelldecor/screens/payment_screens/paymentscreen.dart';
import 'package:campbelldecor/main.dart';
import 'package:flutter/services.dart';
import '../../api/pdf_api.dart';
import '../../api/pdf_invoice_api.dart';
import '../../models/invoice.dart';
import '../../models/supplier.dart';
import '../../models/user_model.dart';
import '../../reusable/reusable_methods.dart';
import '../widget/button_widget.dart';
import '../widget/title_widget.dart';
import 'package:pdf/widgets.dart' as pw;

class pdfscreen extends StatefulWidget {
  const pdfscreen({super.key});

  @override
  State<pdfscreen> createState() => _pdfscreenState();
}

Map<String, dynamic> user = Map();

void setUser() async {
  user = await getUserData(FirebaseAuth.instance.currentUser!.uid);
}

class _pdfscreenState extends State<pdfscreen> {
  // late pw.Image image;
  //
  // Future<void> imageGenerate() async {
  //   final img = await rootBundle.load('assets/images/appLogo1.png');
  //   final imageBytes = img.buffer.asUint8List();
  //
  //   image = pw.Image(pw.MemoryImage(imageBytes));
  // }

  @override
  Widget build(BuildContext context) {
    setUser();
    Map<String, dynamic> event =
        ({'name': 'birthday', 'price': 5000.0, 'date': DateTime.now()});

    // imageGenerate();
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      appBar: AppBar(
        title: Text('Payment Details'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleWidget(
                icon: Icons.picture_as_pdf,
                text: 'Generate Invoice',
              ),
              const SizedBox(height: 48),
              ButtonWidget(
                text: 'Invoice PDF',
                onClicked: () async {
                  // pw.Image image = await imageGenerate();
                  GeneratePDFInvoice(user, event, 'FhkC7ffWvmpOHEeY4L8G', 5000);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
