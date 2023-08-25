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

      // Perform search in each collection reference
      for (var collectionReference in collectionReferences) {
        searchFutures.add(
          collectionReference
              .where('name', isGreaterThanOrEqualTo: searchQuery)
              .get(),
        );
      }

      // Wait for all search queries to complete
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
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _performSearch,
            decoration: InputDecoration(
              hintText: 'Search...',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResultsList.length,
              itemBuilder: (context, collectionIndex) {
                var searchResults = _searchResultsList[collectionIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Results from Collection ${collectionIndex + 1}',
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = searchResults.docs[index]
                            .data() as Map<String, dynamic>;

                        return ListTile(
                          title: Text(data['name'] ?? 'Title not found'),
                          onTap: () {
                            // Add your navigation logic here
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<CollectionReference> collectionReferences = [
  FirebaseFirestore.instance.collection('events'),
  FirebaseFirestore.instance.collection('services'),
  // Add more collections as needed
];
