// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController _searchController = TextEditingController();
//   QuerySnapshot? _searchResults;
//
//   void _performSearch(String searchQuery) async {
//     if (searchQuery.isNotEmpty) {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('events')
//           .where('name', isGreaterThanOrEqualTo: searchQuery)
//           .get();
//
//       setState(() {
//         _searchResults = snapshot;
//       });
//     } else {
//       setState(() {
//         _searchResults = null; // Clear results if search query is empty
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Search')),
//       body: Column(
//         children: [
//           TextField(
//             controller: _searchController,
//             onChanged: _performSearch,
//             decoration: InputDecoration(
//               hintText: 'Search...',
//             ),
//           ),
//           _searchResults != null
//               ? Expanded(
//                   child: ListView.builder(
//                     itemCount: _searchResults?.docs.length ?? 0,
//                     itemBuilder: (context, index) {
//                       Map<String, dynamic> data = _searchResults?.docs[index]
//                           .data() as Map<String, dynamic>;
//
//                       return ListTile(
//                         title: Text(data['name'] ?? 'Title not found'),
//                         onTap: () {
//                           // Add your navigation logic here
//                         },
//                       );
//                     },
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
/****************************************************/

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController _searchController = TextEditingController();
//   QuerySnapshot? _searchResults;
//
//   void _performSearch(String searchQuery) async {
//     if (searchQuery.isNotEmpty) {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('events')
//           .where('name', isGreaterThanOrEqualTo: searchQuery)
//           .get();
//
//       setState(() {
//         _searchResults = snapshot;
//       });
//     } else {
//       setState(() {
//         _searchResults = null; // Clear results if search query is empty
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Search')),
//       body: Column(
//         children: [
//           TextField(
//             controller: _searchController,
//             onChanged: _performSearch,
//             decoration: InputDecoration(
//               hintText: 'Search...',
//             ),
//           ),
//           _searchResults != null
//               ? Expanded(
//                   child: ListView.builder(
//                     itemCount: _searchResults?.docs.length ?? 0,
//                     itemBuilder: (context, index) {
//                       Map<String, dynamic> data = _searchResults?.docs[index]
//                           .data() as Map<String, dynamic>;
//
//                       return ListTile(
//                         title: Text(data['name'] ?? 'Title not found'),
//                         onTap: () {
//                           // Add your navigation logic here
//                         },
//                       );
//                     },
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
/****************************************************/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/color_util.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<QuerySnapshot> _searchResultsList = [];
  void _performSearch(String searchQuery) async {
    if (searchQuery.isNotEmpty) {
      List<Future<QuerySnapshot>> searchFutures = [];
      for (var collectionReference in collectionReferences) {
        var query = collectionReference
            .where('name', isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThan: searchQuery + 'z');
        searchFutures.add(query.get());
      }
      List<QuerySnapshot> results = await Future.wait(searchFutures);
      setState(() {
        _searchResultsList = results;
      });
    } else {
      setState(() {
        _searchResultsList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
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
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _performSearch,
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search_outlined,
                        size: 35,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _searchController.text = '';
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                )),
            Expanded(
                child: ListView.builder(
              itemCount: _searchResultsList.length,
              itemBuilder: (context, collectionIndex) {
                var searchResults = _searchResultsList[collectionIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: searchResults.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name'] ?? 'Title not found'),
                      onTap: () {
                        Navigator.pushNamed(context, '/eventScreen',
                            arguments: data['name']);
                      },
                    );
                  }).toList(),
                );
              },
            ))
          ],
        ));
  }
}

List<CollectionReference> collectionReferences = [
  FirebaseFirestore.instance.collection('events'),
];
