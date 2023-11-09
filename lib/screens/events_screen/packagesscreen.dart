import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../reusable/reusable_methods.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';
import '../bookings_screens/date_view.dart';
import '../bookings_screens/show_rating.dart';
import '../filter_section/filterForPackages.dart';

class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  final CollectionReference _packages =
      FirebaseFirestore.instance.collection('packages');
  PackageFilter _currentFilter = PackageFilter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Packages",
        ),
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
          IconButton(
            onPressed: () {
              // Navigate to the filter screen and pass the current filter
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FilterScreen(
                    packageFilter: _currentFilter,
                    apply: () {
                      applyFilters(_currentFilter);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            icon: Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _packages.snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasData) {
                final filteredPackages = applyFiltersToPackages(
                  streamSnapshot.data!.docs,
                  _currentFilter,
                );
                if (filteredPackages.length > 0) {
                  return LimitedBox(
                      maxHeight: 713,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: filteredPackages.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                filteredPackages[index];
                            final Map<String, dynamic> service =
                                documentSnapshot['services'];

                            List<Widget> listItems = [];

                            service.forEach((key, value) {
                              listItems.add(
                                ListTile(
                                  title: Text(key),
                                  subtitle: Text(value.toString()),
                                ),
                              );
                            });
                            return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shadowColor: Colors.black,
                                              elevation: 8,
                                              icon: const Icon(
                                                Icons.event,
                                                color: Colors.blue,
                                                size: 60,
                                              ),
                                              title: Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "${documentSnapshot['packageName']}",
                                                  ),
                                                ),
                                              ),
                                              content: Container(
                                                height: 350,
                                                width: 300,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Total Amount : ${documentSnapshot['price']}",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Services : ",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18),
                                                      ),
                                                      LimitedBox(
                                                        maxHeight: 300,
                                                        child: ListView(
                                                          children: listItems,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    SharedPreferences
                                                        preferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    await preferences.setString(
                                                        'package',
                                                        documentSnapshot[
                                                            'packageName']);
                                                    await preferences.setDouble(
                                                        'packageAmount',
                                                        documentSnapshot[
                                                                'price']
                                                            .toDouble());
                                                    Navigation(context,
                                                        CalendarScreen());
                                                  },
                                                  child: const Text('OK',
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 10,
                                        child: Container(
                                            height: 200,
                                            width: 350,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  documentSnapshot['imgURL'],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Stack(children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: ListTile(
                                                  //----------------------Text Container background ----------------------//

                                                  title: Container(
                                                    height: 70,
                                                    width: 300,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                    ),
                                                    //----------------------Text Editings----------------------//
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        documentSnapshot[
                                                            'packageName'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: ListTile(
                                                      //----------------------Text Container background ----------------------//

                                                      title: Container(
                                                          height: 40,
                                                          width: 300,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                          //----------------------Text Editings----------------------//
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      ShowRatingBar(
                                                                        maxRating:
                                                                            5,
                                                                        initialRating:
                                                                            documentSnapshot['avg_rating'].toDouble(),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            16,
                                                                      ),
                                                                      Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5.0),
                                                                          child:
                                                                              Text(
                                                                            documentSnapshot['rating_count'].toString(),
                                                                            style:
                                                                                const TextStyle(color: Colors.grey),
                                                                          ))
                                                                    ])
                                                              ]))))
                                            ])))));
                          }));
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text("No packages Available"),
                    ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: bottom_Bar(context),
    );
  }

  List<DocumentSnapshot> applyFiltersToPackages(
    List<QueryDocumentSnapshot> packages,
    PackageFilter filter,
  ) {
    var filteredPackages = packages;

    if (filter.minPrice != null) {
      filteredPackages = filteredPackages
          .where((package) => package['price'] >= filter.minPrice!)
          .toList();
    }
    if (filter.maxPrice != null) {
      filteredPackages = filteredPackages
          .where((package) => package['price'] <= filter.maxPrice!)
          .toList();
    }
    if (filter.eventName != null) {
      filteredPackages = filteredPackages
          .where((package) => package['packageName'] == filter.eventName)
          .toList();
    }
    //
    // Apply rating range filter
    // if (filter.minRating != null) {
    //   filteredPackages = filteredPackages
    //       .where((package) => package['rating'] >= filter.minRating!)
    //       .toList();
    // }
    // if (filter.maxRating != null) {
    //   filteredPackages = filteredPackages
    //       .where((package) => package['rating'] <= filter.maxRating!)
    //       .toList();
    // }

    // Apply order by
    if (filter.ascendingOrder) {
      filteredPackages.sort((a, b) => a['price'].compareTo(b['price']));
    } else {
      filteredPackages.sort((a, b) => b['price'].compareTo(a['price']));
    }

    return filteredPackages;
  }

  // Function to apply filters when filter screen is closed
  void applyFilters(PackageFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
  }
}
