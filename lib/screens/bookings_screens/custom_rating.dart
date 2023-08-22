// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(CustomRatingApp());
// }
//
// class CustomRatingApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Custom Rating Bar'),
//         ),
//         body: Center(
//           child: CustomRatingBar(
//             maxRating: 5,
//             initialRating: 3.0,
//             onRatingChanged: (rating) {
//               print('New rating: $rating');
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomRatingBar extends StatefulWidget {
//   final int maxRating;
//   final double initialRating;
//   final Function(double) onRatingChanged;
//
//   CustomRatingBar({
//     this.maxRating = 5,
//     this.initialRating = 0.0,
//     required this.onRatingChanged,
//   });
//
//   @override
//   _CustomRatingBarState createState() => _CustomRatingBarState();
// }
//
// class _CustomRatingBarState extends State<CustomRatingBar> {
//   double _rating = 0.0;
//   bool _ratingSubmitted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _rating = widget.initialRating;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(
//             widget.maxRating,
//             (index) => GestureDetector(
//               onTap: () {
//                 if (!_ratingSubmitted) {
//                   setState(() {
//                     _rating = index + 1.0;
//                   });
//                 }
//               },
//               child: Icon(
//                 _rating >= index + 1 ? Icons.star : Icons.star_border,
//                 color: _rating >= index + 1 ? Colors.amber : Colors.grey,
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 16.0),
//         if (!_ratingSubmitted)
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _ratingSubmitted = true;
//                 widget.onRatingChanged(_rating);
//               });
//             },
//             child: Text("Submit Rating"),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

//  CustomRatingBar(
//             maxRating: 5,
//             initialRating: 60, // Initial rating as percentage (0 to 100)
//             onRatingChanged: (rating) {
//               print('New rating: $rating');
//             },
//           )
class CustomRatingBar extends StatefulWidget {
  final int maxRating;
  final double initialRating;
  final Function(double) onRatingChanged;

  CustomRatingBar({
    this.maxRating = 5,
    this.initialRating = 0.0,
    required this.onRatingChanged,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                ),
              );
            },
          ),
        ),
        SizedBox(height: 30.0),
        if (!_ratingSubmitted)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _ratingSubmitted = true;
                widget.onRatingChanged(_rating);
              });
            },
            child: Text("Submit Rating"),
          )
      ],
    );
  }
}
