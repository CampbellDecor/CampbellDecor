import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';

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
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringtoColor("CB2893"),
                hexStringtoColor("9546C4"),
                hexStringtoColor("5E61F4")
              ], begin: Alignment.bottomRight, end: Alignment.topLeft),
            ),
          ),
        ),
        bottomNavigationBar: bottom_Bar(context, 0),
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
                  leading: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                  ),
                  title: Text('Campbell Town,NSW,Australia,2560'),
                  subtitle: Text('Address'),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.blue,
                  ),
                  title: Text('+61 410 734 436'),
                  subtitle: Text('Mobile'),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.email_outlined,
                    color: Colors.red,
                  ),
                  title: Text('campbelldecorau@gmail.com'),
                  subtitle: Text('Email'),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.link,
                    color: Colors.blue,
                  ),
                  title: Text('http://www.campbelldecor.com.au/'),
                  subtitle: Text('Website'),
                ),
              ],
            )));
  }
}
