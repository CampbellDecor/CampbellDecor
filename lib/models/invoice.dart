import 'dart:ui';
import 'package:pdf/widgets.dart' as pw;
import 'package:campbelldecor/models/supplier.dart';
import 'package:campbelldecor/models/user_model.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final pw.Image image;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.image,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
  });
}

class InvoiceItem {
  final String description;
  final DateTime eventDate;
  final double amount;

  const InvoiceItem({
    required this.description,
    required this.eventDate,
    required this.amount,
  });
}
