import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../reusable/reusable_widgets.dart';

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
        bottomNavigationBar: bottom_Bar(context),
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
