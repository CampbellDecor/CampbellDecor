import 'package:campbelldecor/screens/events_screen/servicesscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../reusable/reusable_methods.dart';
import '../../utils/color_util.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now().add(Duration(days: 10));
  Set<DateTime> _disabledDates = Set();
  DateTime? _selectedDay;

  Future<Set<DateTime>> getDatesFromFirestore(dynamic dates) async {
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('bookings');
    QuerySnapshot querySnapshot =
        await eventsCollection.where('status', isEqualTo: 'active').get();
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
    DateTime _firstDay = DateTime.now().add(Duration(days: 10));
    DateTime _lastDay = DateTime.now().add(Duration(days: 90));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await resetSharedPreferences(context);
          },
        ),
        title: Text('Event Calendar'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 90, 20, 0),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white60),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Selected Day = ' + _focusedDay.toString().split(" ")[0],
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
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
                color: Colors.redAccent.withOpacity(0.8),
              ),
              disabledTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(200, 8.0, 0, 30),
            child: Material(
              elevation: 28,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      hexStringtoColor("815ef4"),
                      hexStringtoColor("bc6dd0"),
                      hexStringtoColor("db4baa"),
                    ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                    borderRadius: BorderRadius.circular(15)),
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    elevation: 18,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
