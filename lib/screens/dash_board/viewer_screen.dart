import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/usercredential/signinscreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../utils/color_util.dart';
import '../bookings_screens/show_rating.dart';

class ViewerScreen extends StatefulWidget {
  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  bool isplaying = false;
  final controller = ConfettiController();
  @override
  void initState() {
    super.initState();
    controller.play();
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
    CarouselController carouselController = CarouselController();
    int _currentSlide = 0;
    return Scaffold(
      backgroundColor: hexStringtoColor('efefef'),
      appBar: AppBar(
        leading: Image.asset("assets/images/appLogo1.png"),
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
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
            child: TextButton(
              onPressed: () {
                Navigation(context, const SignInScreen());
              },
              child: Row(
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Icon(
                    Icons.login_sharp,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
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
                                      Navigation(context, SignInScreen());
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
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      elevation: 5,
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.white70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "More Packages",
                      style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: 'OpenSans'),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage('assets/images/quote1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 200,
                      width: 350,
                      child: Stack(
                        children: [
                          Container(
                            height: 250,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  Text(
                                    '\" Turning your visions into unforgettable moments – trust us, the experts in event planning. \"',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'Alegreya',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(98, 0, 0, 0),
                                    child: Text(
                                      '-Cambell Decor',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Alegreya',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 10,
                                    child: Container(
                                      height: 150,
                                      width: 300,
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
                                                    fontSize: 20,
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
                      elevation: 5,
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.white70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "More Events",
                      style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: 'OpenSans'),
                    ),
                    onPressed: () {
                      Navigation(context, SignInScreen());
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 10,
                                    child: Container(
                                      height: 150,
                                      width: 300,
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
                                                    fontSize: 20,
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
                      elevation: 5,
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.white70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "More Services",
                      style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: 'OpenSans'),
                    ),
                    onPressed: () {
                      Navigation(context, SignInScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
