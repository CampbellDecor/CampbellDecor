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
  String _selectedFilter = 'All'; // Default filter

  void _performSearch(String searchQuery) async {
    if (searchQuery.isNotEmpty) {
      List<Future<QuerySnapshot>> searchFutures = [];

      // Perform search in each collection reference based on the selected filter
      for (var collectionReference in collectionReferences) {
        var query = collectionReference
            .where('name', isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThan: searchQuery + 'z');

        if (_selectedFilter != 'All') {
          query = query.where('type', isEqualTo: _selectedFilter);
        }

        searchFutures.add(query.get());
      }

      // Wait for all search queries to complete
      List<QuerySnapshot> results = await Future.wait(searchFutures);

      setState(() {
        // Merge the results into a single list
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
        actions: [
          // Add a filter dropdown button
          DropdownButton<String>(
            value: _selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });

              // Perform a new search based on the selected filter
              _performSearch(_searchController.text);
            },
            items: ['All', 'Events', 'Services', 'Packages']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
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
                  children: searchResults.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(data['name'] ?? 'Title not found'),
                      onTap: () {
                        // Add navigation logic here
                      },
                    );
                  }).toList(),
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
];
