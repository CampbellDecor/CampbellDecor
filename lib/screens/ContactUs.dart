import 'package:campbelldecor/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:campbelldecor/screens/homescreen.dart';
import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/Chat.dart';

import 'bookings_screens/cart_screen.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyContact(),
  ));
}

class MyContact extends StatefulWidget {
  @override
  _MyContactState createState() => _MyContactState();
}

class _MyContactState extends State<MyContact> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('ContactUs'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.black,
          elevation: 20,

          //currentIndex: ,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home, // Replace this with the desired icon for the route
                size: 40,
              ),
              label: 'Home', // The label for accessibility (optional)
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat, // Replace this with the desired icon for the route
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
                    .shopping_cart, // Replace this with the desired icon for the route
                size: 40,
              ),
              label: 'Settings', // The label for accessibility (optional)
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons
                    .search, // Replace this with the desired icon for the route
                size: 40,
              ),
              label: 'Settings', // The label for accessibility (optional)
            ),
          ],
          onTap: (index) {
            // Handle navigation here based on the selected index
            if (index == 0) {
              _navigateToHome(context);
            } else if (index == 1) {
              _navigateToChat(context);
            } else if (index == 2) {
              _navigateToEvents(context);
            } else if (index == 3) {
              _navigateToCart(context);
            } else {
              _navigateToSearch(context);
            }
          },
        ),
        body: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us:',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Campbell Town,NSW,Australia,2560'),
                  subtitle: Text('Address'),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('+61 410 734 436'),
                  subtitle: Text('Mobile'),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('campbelldecorau@gmail.com'),
                  subtitle: Text('Email'),
                ),
                ListTile(
                  leading: Icon(Icons.web),
                  title: Text('http://www.campbelldecor.com.au/'),
                  subtitle: Text('Website'),
                ),
              ],
            )));
  }
}

void _navigateToEvents(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EventsScreen()),
  );
}

void _navigateToChat(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChatPage()),
  );
}

void _navigateToHome(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
  );
}

void _navigateToCart(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddToCartScreen()),
  );
}

void _navigateToSearch(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChatPage()),
  );
}
