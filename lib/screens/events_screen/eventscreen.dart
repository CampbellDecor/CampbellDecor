import 'package:campbelldecor/screens/bookings_screens/date_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../reusable/reusable_methods.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';

class EventsScreen extends StatefulWidget {
  final String name;
  EventsScreen({required this.name});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class EventFilter {
  String? eventName;
}

class _EventsScreenState extends State<EventsScreen> {
  final CollectionReference _events =
      FirebaseFirestore.instance.collection('events');
  EventFilter _currentFilter = EventFilter();

  @override
  void initState() {
    super.initState();

    ();
  }

  void filterEvents(String data) {
    setState(() {
      _currentFilter.eventName = widget.name;
    });
  }

  List<DocumentSnapshot> applyFiltersToEvents(
    List<QueryDocumentSnapshot> events,
    EventFilter filter,
  ) {
    var filteredEvents = events;
    if (filter.eventName != null) {
      if (filter.eventName == 'more') {
      } else {
        filteredEvents = filteredEvents
            .where((event) => event['name'] == filter.eventName)
            .toList();
      }
    }

    return filteredEvents;
  }

  @override
  Widget build(BuildContext context) {
    final String data = widget.name;
    filterEvents(data);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Events ",
        ),
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
      body: Stack(fit: StackFit.expand, children: [
        SingleChildScrollView(
            child: Column(children: [
          StreamBuilder<QuerySnapshot>(
              stream: _events.snapshots(),
              builder: (context, streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final filteredEvents = applyFiltersToEvents(
                    streamSnapshot.data!.docs,
                    _currentFilter,
                  );
                  return LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.84,
                    child: ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              filteredEvents[index];
                          return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(50, 10, 50, 10),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 10,
                                  child: GestureDetector(
                                      onTap: () async {
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        preferences.setString(
                                            'event', documentSnapshot['name']);
                                        Navigation(context, CalendarScreen());
                                      },
                                      child: Container(
                                          height: 180,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                documentSnapshot['imgURL'],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Stack(children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                            Align(
                                                alignment: Alignment.center,
                                                child: ListTile(
                                                  //----------------------Text Container background ----------------------//

                                                  title: Container(
                                                    height: 70,
                                                    width: double.infinity,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                    ),
                                                    //----------------------Text Editings----------------------//
                                                    child: Text(
                                                      documentSnapshot['name'],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                          ])))));
                        }),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })
        ]))
      ]),
      bottomNavigationBar: bottom_Bar(context),
    );
  }
}
