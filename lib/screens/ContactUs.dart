import 'package:campbelldecor/screens/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/Chat.dart';

import '../reusable/reusable_methods.dart';
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
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor: Colors.purple, // Selected icon color
            textTheme: Theme.of(context).textTheme.copyWith(
                  bodySmall: const TextStyle(
                      color: Colors.grey), // Unselected icon color
                ),
          ),
          child: CupertinoTabBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chat_bubble_text_fill),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.add),
                  label: 'Add',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.cart_badge_plus),
                  label: 'Add',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search),
                  label: 'Search',
                ),
              ],
              // currentIndex: _selectedIndex,
              onTap: (index) {
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
              }),
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
