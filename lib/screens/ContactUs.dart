import 'package:campbelldecor/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/Chat.dart';

import 'bookings_screens/cart_screen.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ContactUs'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.black,
          elevation: 20,

          //currentIndex: ,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 40,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 30,
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
                size: 40,
              ),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                size: 40,
              ),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 40,
              ),
              label: 'Settings',
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
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us:',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 8),
                const ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Campbell Town,NSW,Australia,2560'),
                  subtitle: Text('Address'),
                ),
                const ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('+61 410 734 436'),
                  subtitle: Text('Mobile'),
                ),
                const ListTile(
                  leading: Icon(Icons.email),
                  title: Text('campbelldecorau@gmail.com'),
                  subtitle: Text('Email'),
                ),
                const ListTile(
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
