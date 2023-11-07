import 'package:campbelldecor/screens/bookings_screens/date_view.dart';
import 'package:campbelldecor/screens/events_screen/religion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../reusable/reusable_methods.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';

class EventsScreen extends StatefulWidget {
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final CollectionReference _events =
      FirebaseFirestore.instance.collection('events');
  /************----***************/
  List<DocumentSnapshot> filteredEvents = [];

  void filterEvents(String data) {
    Fluttertoast.showToast(
        msg: "your message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black);
    final query = data.toLowerCase();
    _events
        .where('names', isGreaterThanOrEqualTo: query)
        .get()
        .then((querySnapshot) {
      setState(() {
        filteredEvents = querySnapshot.docs;
      });
    });
  }

  /************----***************/
  @override
  Widget build(BuildContext context) {
    final String data = ModalRoute.of(context)!.settings.arguments.toString();
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
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return LimitedBox(
                    maxHeight: 720,
                    child: ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
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
                                          ]))))
                              // ),
                              );
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
