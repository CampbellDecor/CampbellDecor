import 'package:flutter/material.dart';

class ShowRatingBar extends StatefulWidget {
  final int maxRating;
  final double initialRating;

  ShowRatingBar({
    this.maxRating = 5,
    this.initialRating = 0.0,
  });

  @override
  _ShowRatingBarState createState() => _ShowRatingBarState();
}

class _ShowRatingBarState extends State<ShowRatingBar> {
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            widget.maxRating,
            (index) {
              double fillPercentage = (index + 1) * 20;
              bool isFilled = _rating >= fillPercentage;
              return Icon(
                isFilled ? Icons.star : Icons.star_border,
                color: isFilled ? Colors.amber : Colors.grey,
                size: 20,
              );
            },
          ),
        ),
      ],
    );
  }
}
