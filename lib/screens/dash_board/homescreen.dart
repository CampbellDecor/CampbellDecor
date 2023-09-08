import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/notifications/notification_services.dart';
import 'package:campbelldecor/screens/theme/theme_manager.dart';
import 'package:campbelldecor/screens/usercredential/signinscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../reusable/reusable_widgets.dart';
import '../bookings_screens/date_view.dart';
import '../bookings_screens/show_rating.dart';
import 'header_nav.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupIneractMessage(context);
    notificationServices.getDeviceToken().then((value) {
      print('device Token');
      print('Device Token $value');
    });
  }

  @override
  void _openDrawer(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference _packages =
        FirebaseFirestore.instance.collection('packages');
    final CollectionReference _events =
        FirebaseFirestore.instance.collection('events');
    final CollectionReference _services =
        FirebaseFirestore.instance.collection('services');

    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Campbell Decor'),
        backgroundColor: Colors.purple[700],
        /* Dark mood and Light mode button */
        actions: [
          Switch(
            value: themeManager.themeMode == ThemeMode.dark,
            onChanged: (newValue) {
              setState(() {
                themeManager.toggleTheme(newValue);
              });
            },
            inactiveTrackColor: Colors.yellow[200],
            activeColor: Colors.blue[900],
            inactiveThumbColor: Colors.yellow,
            inactiveThumbImage: const AssetImage('assets/images/sun1.png'),
            activeThumbImage: const AssetImage('assets/images/moon.png'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active_rounded),
            onPressed: () {
              // Navigation(context, NotificationView());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
              Navigation(context, const SignInScreen());
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image.asset(
          //   'assets/images/back2.png', // Replace with your image path
          //   fit: BoxFit.cover, // Adjust how the image fits the screen
          // ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Packages',
                    style: TextStyle(fontSize: 20, color: Colors.pink),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: _packages.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return LimitedBox(
                          maxHeight: 240,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 10,
                                    child: Container(
                                      height: 200,
                                      width: 350,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        // image: DecorationImage(
                                        //   image: NetworkImage(
                                        //     documentSnapshot['imgURL'],
                                        //   ),
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: ListTile(
                                              //----------------------Text Container background ----------------------//

                                              title: Container(
                                                height: 70,
                                                width: 300,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                //----------------------Text Editings----------------------//
                                                child: Text(
                                                  documentSnapshot[
                                                      'packageName'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: ListTile(
                                              //----------------------Text Container background ----------------------//

                                              title: Container(
                                                height: 40,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                ),
                                                //----------------------Text Editings----------------------//
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ShowRatingBar(
                                                          maxRating: 5,
                                                          initialRating:
                                                              documentSnapshot[
                                                                      'avg_rating']
                                                                  .toDouble(),
                                                        ),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Text(
                                                            documentSnapshot[
                                                                    'rating_count']
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "More",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MyPackage()),
                      // );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Events',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: _events.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return LimitedBox(
                          maxHeight: 240,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 10,
                                    child: Container(
                                      height: 200,
                                      width: 350,
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: ListTile(
                                              //----------------------Text Container background ----------------------//

                                              title: Container(
                                                height: 70,
                                                width: 300,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                //----------------------Text Editings----------------------//
                                                child: Text(
                                                  documentSnapshot['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
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
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "More",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      Navigation(context, EventsScreen());
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Services',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _services.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return LimitedBox(
                          maxHeight: 240,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 10,
                                    child: Container(
                                      height: 200,
                                      width: 350,
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: ListTile(
                                              //----------------------Text Container background ----------------------//

                                              title: Container(
                                                height: 70,
                                                width: 300,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                //----------------------Text Editings----------------------//
                                                child: Text(
                                                  documentSnapshot['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
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
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "More",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      Navigation(context, CalendarScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottom_Bar(context),
    );
  }
}
