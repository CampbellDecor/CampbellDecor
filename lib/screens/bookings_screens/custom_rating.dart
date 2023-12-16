import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomRatingBar extends StatefulWidget {
  final int maxRating;
  final double initialRating;
  final Function(double) onRatingChanged;
  final String pid;
  final String bid;

  CustomRatingBar({
    this.maxRating = 5,
    this.initialRating = 0.0,
    required this.onRatingChanged,
    required this.pid,
    required this.bid,
  });

  @override
  _CustomRatingBarState createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar> {
  int? _countUser;
  double _rating = 0.0;
  bool _ratingSubmitted = false;
  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  Future<void> updateRating(String id) async {
    double avgRating;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("packages");
    DocumentSnapshot snapshot = await collectionReference.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _countUser = data['rating_count'] + 1;
    avgRating =
        ((data['avg_rating'] * data['rating_count']) + _rating) / _countUser;

    /******************------------ Update Rating into firebase ---------------**********************/
    await FirebaseFirestore.instance
        .collection('packages')
        .doc(id)
        .update({'avg_rating': avgRating, 'rating_count': _countUser});

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.bid)
        .update({'isRated': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_rating == 20)
              Text(
                Emoji.byName('angry face').toString(),
                style: TextStyle(fontSize: 40),
              ),
            if (20 < _rating && _rating <= 40)
              Text(
                Emoji.byName('sad but relieved face').toString(),
                style: TextStyle(fontSize: 40),
              ),
            if (40 < _rating && _rating <= 60)
              Text(
                Emoji.byName('neutral face').toString(),
                style: TextStyle(fontSize: 40),
              ),
            if (60 < _rating && _rating <= 80)
              Text(
                Emoji.byName('grinning face with big eyes').toString(),
                style: TextStyle(fontSize: 40),
              ),
            if (80 < _rating && _rating <= 100)
              Text(
                Emoji.byName('smiling face with heart-eyes').toString(),
                style: TextStyle(fontSize: 40),
              ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.maxRating,
                (index) {
                  double fillPercentage = (index + 1) * 20;
                  bool isFilled = _rating >= fillPercentage;

                  return GestureDetector(
                    onTap: () {
                      if (!_ratingSubmitted) {
                        setState(() {
                          _rating = fillPercentage;
                        });
                      }
                    },
                    child: Icon(
                      isFilled ? Icons.star : Icons.star_border,
                      color: isFilled ? Colors.amber : Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.0),
            if (!_ratingSubmitted)
              ElevatedButton(
                onPressed: () async {
                  showToast("Thank you for the feedback.");
                  setState(() async {
                    await updateRating(widget.pid);
                    _ratingSubmitted = true;
                    widget.onRatingChanged(_rating);
                    Navigator.of(context).pop();
                  });
                },
                child: Text("Submit Rating"),
              ),
          ],
        ),
      ),
    );
  }
}
