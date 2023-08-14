import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/events_screen/servicesscreen.dart';
import 'package:campbelldecor/screens/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'header_nav.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void _openDrawer(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Campbell Decor'),
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => NotificationPage()),
              // );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => NotificationPage()),
              // );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Packages',
                style: TextStyle(fontSize: 20, color: Colors.pink),
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
                        borderRadius: BorderRadius.circular(
                            10), // Adding a rounded border
                        color: Colors.pink, // Background color
                      ),
                      width: 150,
                      margin: const EdgeInsets.all(10),
                      // color: Colors.pink, // Removed color from here, as it's set in the BoxDecoration
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MyPackage()),
                  // );
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
            ],
          ),
        ),
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
            // _navigateToHome(context);
          } else if (index == 1) {
            // _navigateToChat(context);
          } else if (index == 2) {
            // _navigateToEvents(context);
          } else if (index == 3) {
            // _navigateToCart(context);
          } else {
            // _navigateToSearch(context);
          }
        },
      ),
    );
  }
}
