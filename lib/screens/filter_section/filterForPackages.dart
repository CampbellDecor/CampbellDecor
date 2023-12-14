import 'package:flutter/material.dart';
import '../../utils/color_util.dart';

class FilterScreen extends StatefulWidget {
  final PackageFilter packageFilter;
  final Function() apply;
  FilterScreen({required this.packageFilter, required this.apply});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class PackageFilter {
  double? minPrice;
  double? maxPrice;
  bool ascendingOrder = true;
  String? eventName;
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters By'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CB2893"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61F4")
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Price Range',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            RangeSlider(
              divisions: 20,
              activeColor: Colors.pink[400],
              inactiveColor: Colors.black38,
              values: RangeValues(
                widget.packageFilter.minPrice ?? 0,
                widget.packageFilter.maxPrice ?? 100000,
              ),
              min: 0,
              max: 100000,
              onChanged: (RangeValues values) {
                setState(() {
                  widget.packageFilter.minPrice = values.start;
                  widget.packageFilter.maxPrice = values.end;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Min: \$${widget.packageFilter.minPrice?.toStringAsFixed(2) ?? "N/A"}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Max: \$${widget.packageFilter.maxPrice?.toStringAsFixed(2) ?? "N/A"}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            Text(
              'Order By',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: widget.packageFilter.ascendingOrder,
                  onChanged: (value) {
                    setState(() {
                      widget.packageFilter.ascendingOrder = value!;
                    });
                  },
                ),
                Text(
                  'Ascending',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
                Radio(
                  value: false,
                  groupValue: widget.packageFilter.ascendingOrder,
                  onChanged: (value) {
                    setState(() {
                      widget.packageFilter.ascendingOrder = value!;
                    });
                  },
                ),
                Text(
                  'Descending',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    try {
                      widget.apply();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Apply Filters'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.packageFilter.minPrice = null;
                    widget.packageFilter.maxPrice = null;
                    widget.packageFilter.ascendingOrder = true;
                    widget.packageFilter.eventName = null;
                    widget.apply();
                  },
                  child: Text('Clear Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
