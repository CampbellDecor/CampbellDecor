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
  String? eventName; // Add a property to store event name
  double? minRating; // Add a property for minimum rating
  double? maxRating; // Add a property for maximum rating
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
              max: 100,
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

            // Event Name Filter
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

            // Order By Filter
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

            // Apply and Clear Buttons
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.applyFilters();
                    Navigator.of(context).pop();
                  },
                  child: Text('Apply Filters'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Clear filters
                    widget.packageFilter.minPrice = null;
                    widget.packageFilter.maxPrice = null;
                    widget.packageFilter.ascendingOrder = true;
                    widget.packageFilter.eventName =
                        null; // Clear event name filter
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
