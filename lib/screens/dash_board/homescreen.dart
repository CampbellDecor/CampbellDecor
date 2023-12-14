import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/notifications/notification_history.dart';
import 'package:campbelldecor/screens/theme/theme_manager.dart';
import 'package:campbelldecor/screens/usercredential/signinscreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';
import '../bookings_screens/date_view.dart';
import '../bookings_screens/show_rating.dart';
import '../events_screen/packagesscreen.dart';
import 'CountdownTimer.dart';
import '../notifications/notification_detail.dart';
import 'header_nav.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isplaying = false;
  late int days;
  late String firstEvent;
  final controller = ConfettiController();

  @override
  void initState() {
    super.initState();
    controller.play();
    setOutDatedBooking();
    updateDeviceTokenForNotification(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<Map<String, dynamic>> calculateDaysDifference() async {
    Map<String, dynamic> dates = await fetchDataFromFirebase(
        'bookings', 'eventDate', FirebaseAuth.instance.currentUser!.uid);
    DateTime now = DateTime.now();
    Duration difference = dates['eventDate'].toDate().difference(now);
    return {'days': difference.inDays, 'name': dates['name']};
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
    CarouselController carouselController = CarouselController();
    int _currentSlide = 0;
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Campbell Decor'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CB2893"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61F4")
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
        /**---------------------- Dark mood and Light mode button ------------------**/
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
              Navigation(context, NotificationHistory());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
              Navigation(context, SignInScreen());
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          ConfettiWidget(
            confettiController: controller,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.08,
            numberOfParticles: 10,
            minBlastForce: 5,
            maxBlastForce: 100,
            gravity: 0.8,
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Packages',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AbrilFatface',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                      stream: _packages.snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return LimitedBox(
                            maxHeight: 240,
                            maxWidth: 900,
                            child: CarouselSlider.builder(
                              itemCount: 5,
                              carouselController: carouselController,
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 6),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 3000),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                aspectRatio: 2,
                                onPageChanged: (index, realIndex) {
                                  setState(() {
                                    _currentSlide = index;
                                  });
                                },
                              ),
                              itemBuilder: (context, index, realIndex) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigation(context, PackageScreen());
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 10,
                                      child: Container(
                                        height: 200,
                                        width: 300,
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
                                        child: Stack(
                                          children: [
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
                                                  width: 300,
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
                                                    documentSnapshot[
                                                        'packageName'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'AbrilFatface'),
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
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
                                                  //----------------------Text Editings----------------------//
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                                    .all(8.0),
                                                            child: Text(
                                                              documentSnapshot[
                                                                      'rating_count']
                                                                  .toString(),
                                                              style: const TextStyle(
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
                                  ),
                                  // ),
                                );
                              },
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        splashFactory: InkRipple.splashFactory,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                        elevation: 3,
                        side: BorderSide(color: Colors.white70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: hexStringtoColor('aea1fb')),
                    child: SizedBox(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "More Packages",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PackageScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                      future: calculateDaysDifference(),
                      builder: (contex, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(' ');
                        } else {
                          days = snapshot.data!['days'];
                          firstEvent = snapshot.data!['name'];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Container(
                                  height: 200,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white70,
                                  ),
                                  child: CountdownTimer(
                                    initialDays: days,
                                    event: firstEvent,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Events',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AbrilFatface',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: _events.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return LimitedBox(
                          maxHeight: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      preferences.setString(
                                          'event', documentSnapshot['name']);
                                      Navigation(context, CalendarScreen());
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 10,
                                      child: Container(
                                        height: 150,
                                        width: 300,
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
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black
                                                    .withOpacity(0.4),
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
                                                        fontFamily:
                                                            'AbrilFatface'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                        splashFactory: InkRipple.splashFactory,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                        elevation: 3,
                        side: BorderSide(color: Colors.white70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: hexStringtoColor('aea1fb')),
                    child: SizedBox(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "More events",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigation(
                          context,
                          EventsScreen(
                            name: 'more',
                          ));
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Services',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AbrilFatface',
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _services.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return LimitedBox(
                          maxHeight: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigation(context, CalendarScreen());
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 10,
                                      child: Container(
                                        height: 150,
                                        width: 300,
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
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black
                                                    .withOpacity(0.5),
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
                                                        fontFamily:
                                                            'AbrilFatface'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                        splashFactory: InkRipple.splashFactory,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                        elevation: 3,
                        side: BorderSide(color: Colors.white70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: hexStringtoColor('aea1fb')),
                    child: SizedBox(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "More services",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigation(context, CalendarScreen());
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottom_Bar(context, 0),
    );
  }
}
