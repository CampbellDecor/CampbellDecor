import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../reusable/reusable_widgets.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: new Text('AboutUs'),
        ),
        bottomNavigationBar: bottom_Bar(context),
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
                      'assets/images/logo2.png',
                      width: 300,
                      height: 170,
                      fit: BoxFit.cover,
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
