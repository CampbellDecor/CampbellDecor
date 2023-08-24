import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/bookings_screens/cart_screen.dart';
import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/notifications/notificationView.dart';
import 'package:campbelldecor/screens/notifications/notification_services.dart';
import 'package:campbelldecor/screens/theme/theme_manager.dart';
import 'package:campbelldecor/screens/usercredential/signinscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ratingModel.dart';
import 'bookings_screens/date_view.dart';
import 'bookings_screens/show_rating.dart';
import 'events_screen/religion.dart';
import 'events_screen/usereventscreation.dart';
import 'header_nav.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    super.initState();
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
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Campbell Decor'),
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
            activeThumbImage: const AssetImage(
                'assets/images/moon.png'), // Custom image for the ON state
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
              Navigation(context, SignInScreen());
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
                          maxHeight: 250,
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
                                                        SizedBox(
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
                                                            style: TextStyle(
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
                    child: const Text(
                      "More",
                      style: TextStyle(
                        color: Colors.green,
                      ),
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
                  Container(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green, // Background color
                          ),
                          width: 150,
                          margin: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              'Item $index',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  OutlinedButton(
                    child: const Text(
                      "More",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Services',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue, // Background color
                          ),
                          width: 150,
                          margin: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              'Item $index',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  OutlinedButton(
                    child: const Text(
                      "More",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[500],
        elevation: 20,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              LineAwesomeIcons
                  .home, // Replace this with the desired icon for the route
              size: 30,
            ),
            label: 'Home', // The label for accessibility (optional)
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons
                  .chat_outlined, // Replace this with the desired icon for the route
              size: 30,
            ),
            label: 'Chat', // The label for accessibility (optional)
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons
                  .add_circle_outline, // Replace this with the desired icon for the route
              size: 40,
            ),
            label: 'Events', // The label for accessibility (optional)
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons
                  .add_shopping_cart_outlined, // Replace this with the desired icon for the route
              size: 30,
            ),
            label: 'Settings', // The label for accessibility (optional)
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons
                  .search_sharp, // Replace this with the desired icon for the route
              size: 35,
            ),
            label: 'Settings', // The label for accessibility (optional)
          ),
        ],
        onTap: (index) {
          // Handle navigation here based on the selected index
          if (index == 0) {
            Navigation(context, HomeScreen());
          } else if (index == 1) {
            // _navigateToChat(context);
          } else if (index == 2) {
            Navigation(context, EventsScreen());
          } else if (index == 3) {
            Navigation(context, AddToCartScreen());
          } else {
            // _navigateToSearch(context);
          }
        },
      ),
    );
  }
}
