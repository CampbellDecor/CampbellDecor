import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final PackageFilter packageFilter;
  final Function() applyFilters;
  FilterScreen({required this.packageFilter, required this.applyFilters});

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Range Filter
            Text('Price Range'),
            RangeSlider(
              values: RangeValues(
                widget.packageFilter.minPrice ?? 0,
                widget.packageFilter.maxPrice ?? 100,
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
            Text(
              'Min: \$${widget.packageFilter.minPrice?.toStringAsFixed(2) ?? "N/A"}',
            ),
            Text(
              'Max: \$${widget.packageFilter.maxPrice?.toStringAsFixed(2) ?? "N/A"}',
            ),
            SizedBox(height: 16),
            Text('Event Name'),
            TextField(
              onChanged: (value) {
                setState(() {
                  widget.packageFilter.eventName = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter Event Name',
              ),
            ),
            SizedBox(height: 16),
            Text('Order By'),
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
                Text('Ascending'),
                Radio(
                  value: false,
                  groupValue: widget.packageFilter.ascendingOrder,
                  onChanged: (value) {
                    setState(() {
                      widget.packageFilter.ascendingOrder = !value!;
                    });
                  },
                ),
                Text('Descending'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    try {
                      widget.applyFilters();
                      // Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Apply Filters'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Clear filters
                    widget.packageFilter.minPrice = null;
                    widget.packageFilter.maxPrice = null;
                    widget.packageFilter.ascendingOrder = true;
                    widget.packageFilter.eventName = null;
                    Navigator.of(context).pop();
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
