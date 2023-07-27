import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('CampBell Decor'),
            accountEmail: const Text('campbelldecor@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset('images/logo.png'),
              ),
            ),
            otherAccountsPictures: [],
          ),
          ListTile(
            title: const Text('View Account'),
            leading: const Icon(Icons.account_box),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyAboutUs()),
              // );
            },
          ),
          const Divider(
            height: 0.1,
          ),
          ListTile(
            title: const Text('View Histroy'),
            leading: const Icon(Icons.history),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyHistroy()),
              // );
            },
          ),
          const Divider(
            height: 0.1,
          ),
          ListTile(
            title: const Text('View To Do List'),
            leading: const Icon(Icons.list),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyToDoList()),
              // );
            },
          ),
          const Divider(
            height: 0.1,
          ),
          ListTile(
            title: const Text('About Us'),
            leading: const Icon(Icons.people),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyAboutUs()),
              // );
            },
          ),
          const Divider(
            height: 0.1,
          ),
          ListTile(
            title: const Text('Contact Us'),
            leading: const Icon(Icons.mail),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyContact()),
              // );
            },
          ),
          const Divider(
            height: 0.1,
          )
        ],
      ),
    );
  }
}
