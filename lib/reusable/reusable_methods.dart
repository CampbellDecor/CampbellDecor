import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ratingModel.dart';

// Get Collection Rows Count
Future<int> getCollectionCount(String collectionName) async {
  try {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(collectionName);
    QuerySnapshot querySnapshot = await collectionRef.get();
    return querySnapshot.size;
  } catch (e) {
    print('Error getting collection count: $e');
    return 0;
  }
}

/*------------------FireStore Service for show rating ------------------------*/
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Package>> retriveFromCollection(
    String collectionName,
    List<String> fieldNames,
  ) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(collectionName).get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Package(
          data[fieldNames[0]], data[fieldNames[1]], data[fieldNames[2]]);
    }).toList();
  }
}

Future<void> Navigation(BuildContext context, dynamic function) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => function));
}

/*------------------Alert box show-----------------------*/

Future<void> showErrorAlert(BuildContext context, String errorMessage) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shadowColor: Colors.black,
        elevation: 8,
        icon: const Icon(
          Icons.error_rounded,
          color: Colors.red,
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Error'),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showInformationAlert(
    BuildContext context, String inform, dynamic function) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shadowColor: Colors.black,
        elevation: 8,
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Colors.blue,
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Information'),
          ),
        ),
        content: Text(
          inform,
          style: TextStyle(color: Colors.blue, fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigation(context, function);
            },
          ),
        ],
      );
    },
  );
}

/*------------------ Get Data from Shared preferences ------------------------*/

Future<String?> getData(dynamic name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(name);
}

Future<double?> getDoubleData(dynamic name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(name);
}

Future<List<String?>> getListData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? list = prefs.getStringList(key);
  return list ?? [];
}

Future<Map<String, dynamic>> getMapData(String service) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonData = prefs.getString(service) ?? '{}'; // Default to empty map
  Map<String, dynamic> mapData = json.decode(jsonData);
  return mapData;
}

/*------------------FireStore Inserting Data collection inside the collection  ------------------------*/
Future<void> insertData(
    String collection,
    String name,
    String UserID,
    DateTime date,
    DateTime eventDate,
    double paymentAmount,
    Map<String, dynamic> myMap) async {
  try {
    CollectionReference parentCollection =
        FirebaseFirestore.instance.collection(collection);
    DocumentReference parentDocument = await parentCollection.add({
      'name': name,
      'userID': UserID,
      'date': date,
      'eventDate': eventDate,
      'paymentAmount': paymentAmount,
    });
    CollectionReference subCollection =
        await parentDocument.collection('service');
    await subCollection.add(myMap);
  } catch (e) {
    print('Error inserting data: $e');
  }
}
