import 'package:campbelldecor/screens/dateview.dart';
import 'package:campbelldecor/screens/events_screen/religion.dart';
import 'package:campbelldecor/screens/events_screen/servicesscreen.dart';
import 'package:campbelldecor/screens/events_screen/usereventscreation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../reusable/reusable_methods.dart';

// Future<void> dataPre() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
// }
// Retrieving data from shared preferences

class EventsScreen extends StatelessWidget {
  final CollectionReference _events =
      FirebaseFirestore.instance.collection('events');

  @override
  Widget build(BuildContext context) {
    print(_events.toString());
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Events ",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _events.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return LimitedBox(
                  maxHeight: 700,
                  child: ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the radius as needed
                            ),
                            elevation: 10,
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    documentSnapshot['imgURL'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(
                                          0.2), // Adjust opacity (0.0 to 1.0) to control the intensity
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
                                              BorderRadius.circular(20),
                                          color: Colors.black.withOpacity(
                                              0.5), // Adjust opacity (0.0 to 1.0) to control the intensity
                                        ),
                                        //----------------------Text Editings----------------------//
                                        child: Text(
                                          documentSnapshot['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        if (documentSnapshot['name'] ==
                                            'Wedding') {
                                          Navigation(
                                              context, ReligionSelectScreen());
                                        } else {
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          preferences.setString('event',
                                              documentSnapshot['name']);
                                          Navigation(context, CalendarScreen());
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // ),
                        );
                      }),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigation(context, UserEventsCreationScreen());
            },
            icon: Icon(LineAwesomeIcons.plus_circle),
            iconSize: 45,
            color: Colors.pink,
          )
        ],
      ),
    );
  }
}
