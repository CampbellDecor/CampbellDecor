// import 'package:flutter/material.dart';
//
// class test1 extends StatefulWidget {
//   const test1({super.key});
//
//   @override
//   State<test1> createState() => _test1State();
// }
//
// class _test1State extends State<test1> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
//         child: Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           width: 600,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50),
//             gradient: LinearGradient(
//               colors: [Colors.blue, Colors.pink],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(30),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Text(
//                         'Name : ',
//                         style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.normal),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Text(
//                         'Event Name : ',
//                         style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.normal),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Text(
//                         'Event Date : ',
//                         style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.normal),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Text(
//                         'Address : ',
//                         style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.normal),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Text(
//                         'Services : ',
//                         style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.normal),
//                       ),
//                     ),
//                     if (5 > 3)
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text('Flower'),
//                           Text('Studios'),
//                           Text('Flower'),
//                           Text('Flower'),
//                         ],
//                       )
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Text(
//                         'Total Amount : ',
//                         style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.normal),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

/******---------------------------------------**************/

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubcollectionScreen extends StatefulWidget {
  @override
  _SubcollectionScreenState createState() => _SubcollectionScreenState();
}

class _SubcollectionScreenState extends State<SubcollectionScreen> {
  List<Map<String, dynamic>> subcollectionData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcollection Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await getSubcollectionData();
              },
              child: Text('Get Subcollection Data'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: subcollectionData.map((data) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.keys.first,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data.values.first.toString()),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getSubcollectionData() async {
    var subcollectionSnapshot = await FirebaseFirestore.instance
        .collection('your_collection_name')
        .doc('parent_document_id')
        .collection('subcollection_name')
        .get();

    subcollectionData.clear();
    subcollectionSnapshot.docs.forEach((doc) {
      subcollectionData.add(doc.data() as Map<String, dynamic>);
    });

    setState(() {}); // Update the UI to display the retrieved data
  }
}

*/
/***************************************************************/
/**/
// import 'package:flutter/material.dart';
//
// class DataToggleExample extends StatefulWidget {
//   @override
//   _DataToggleExampleState createState() => _DataToggleExampleState();
// }
//
// class _DataToggleExampleState extends State<DataToggleExample> {
//   bool isDataVisible = false;
//
//   List<Map<String, dynamic>> subcollectionData = [
//     {'Key 1': 'Value 1'},
//     {'Key 2': 'Value 2'},
//     // Add more data...
//   ];
//
//   void toggleDataVisibility() {
//     setState(() {
//       isDataVisible = !isDataVisible;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Toggle Data Example'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: toggleDataVisibility,
//             child: Text(isDataVisible ? 'Hide Data' : 'Show Data'),
//           ),
//           if (isDataVisible)
//             Column(
//               children: subcollectionData.map((data) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         '${data.keys.first} :-',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       data.values.first.toString(),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(home: DataToggleExample()));
// }

/***************************************************************/
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Expandable List Example')),
        body: ExpandableList(),
      ),
    );
  }
}

class ExpandableList extends StatefulWidget {
  @override
  _ExpandableListState createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {
  List<Item> _data = generateItems(5); // Change the number of items as needed

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _data.map<Widget>((Item item) {
        return ExpansionPanelList(
          elevation: 1,
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              item.isExpanded = !isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(item.headerValue),
                );
              },
              body: ListTile(
                title: Text(item.expandedValue),
              ),
              isExpanded: item.isExpanded,
            ),
          ],
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}
