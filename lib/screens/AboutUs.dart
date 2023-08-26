import 'package:campbelldecor/screens/events_screen/eventscreen.dart';
import 'package:campbelldecor/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:campbelldecor/screens/Chat.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: new AppBar(
          title: new Text('AboutUs'),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: screenWidth,
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Campbell Decor',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      'assets/images/user_1.jpeg',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),

              Container(
                width: screenWidth,
                padding: EdgeInsets.all(8),
                child: Text(
                  'Our organization is helping its customers to have their events more beautiful by ausing different decorative methods.Our event specialists are making our customers events more beautiful with affortable price!',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),

              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mission :',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Our mission is to provide high-quality decorations to make events more beautiful .',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Features:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text('Satisfaction of you is more important'),
                      ),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text('You can choose any type of themes.'),
                      ),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text(
                            'We will come to your place and do the decorations.'),
                      ),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title:
                            Text('You can select according to cultural values'),
                      ),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text('Affortable cost'),
                      ),
                    ],
                  )),

              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Events:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text('wedding'),
                      ),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text('Birth Day'),
                      ),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text('Get Together'),
                      ),
                    ],
                  )),

              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Decorations:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text('Balloon Decoration'),
                      ),
                      ListTile(
                        leading: Icon(Icons.sunny),
                        title: Text('Flower Decoration'),
                      ),
                    ],
                  )),

              //social media
              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )),
            ],
          ),
        ));
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
    MaterialPageRoute(builder: (context) => ChatPage()),
  );
}

void _navigateToSearch(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChatPage()),
  );
}
