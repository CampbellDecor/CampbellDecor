import 'package:campbelldecor/screens/events_screen/servicesscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../reusable/reusable_methods.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now().add(Duration(days: 7));
  Set<DateTime> _disabledDates = Set();
  DateTime? _selectedDay;

  Future<Set<DateTime>> getDatesFromFirestore(dynamic dates) async {
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('bookings');
    QuerySnapshot querySnapshot = await eventsCollection.get();
    querySnapshot.docs.forEach((document) {
      DateTime dateTime = document['eventDate'].toDate();
      dates.add(DateTime.utc(dateTime.year, dateTime.month, dateTime.day));
    });
    return dates;
  }

  Future<void> _fetchDisabledDates() async {
    Set<DateTime> dates = await getDatesFromFirestore(_disabledDates);
    setState(() {
      _disabledDates = dates;
    });
  }

  bool _isDateEnabled(DateTime day) {
    return !_disabledDates.contains(day);
  }

  @override
  void initState() {
    super.initState();
    _fetchDisabledDates();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _firstDay = DateTime.now().add(Duration(days: 7));
    DateTime _lastDay = DateTime.now().add(Duration(days: 90));
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calendar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.pink),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Selected Day = ' + _focusedDay.toString().split(" ")[0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          TableCalendar(
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            enabledDayPredicate: _isDateEnabled,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            availableGestures: AvailableGestures.horizontalSwipe,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              disabledDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent[100],
              ),
              disabledTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(200, 8.0, 0, 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                splashFactory: InkRipple.splashFactory,
              ),
              onPressed: () {
                if (_selectedDay != null) {
                  Navigation(
                      context,
                      ServicesScreen(
                        eventDate: _selectedDay!,
                      ));
                  print(_selectedDay);
                } else {
                  showErrorAlert(context, 'Please Select One');
                }
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
