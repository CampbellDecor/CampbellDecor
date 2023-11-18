import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final int initialDays;
  final String event;

  const CountdownTimer(
      {Key? key, required this.initialDays, required this.event})
      : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late int _days;
  // CountdownTimer(
  // initialDays: 10,
  // )

  @override
  void initState() {
    super.initState();
    _days = widget.initialDays;
    startTimer();
  }

  void startTimer() {
    const oneDay = const Duration(days: 1);
    _timer = Timer.periodic(
      oneDay,
      (Timer timer) {
        setState(() {
          if (_days < 1) {
            timer.cancel();
          } else {
            _days--;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timerText = _days.toString().padLeft(2, '0');
    return Container(
      color: Colors.white70,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.event,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'AbrilFatface',
                  fontWeight: FontWeight.normal,
                  color: Colors.pink.shade400),
            ),
            Text(
              'Remaining',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'AbrilFatface',
                  color: Colors.black54),
            ),
            Text(
              ' $timerText',
              style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'AbrilFatface',
                  color: Colors.pink,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              'Days',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'AbrilFatface',
                  color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
