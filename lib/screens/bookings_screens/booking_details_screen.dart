import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../reusable/reusable_methods.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';
import 'custom_rating.dart';

class BookingScreen extends StatefulWidget {
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late String packageId;
  late String bookingId;

  Future<void> getPackage(String packageName, String id) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection("packages");
      QuerySnapshot snapshot = await collectionReference
          .where('packageName', isEqualTo: packageName)
          .get();
      setState(() {
        packageId = snapshot.docs.first.id;
        bookingId = id;
      });
      print(snapshot.docs.first.id);
    } catch (e) {
      print('Erorr$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking history'),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          final activeBookings = <DocumentSnapshot>[];
          final pendingBookings = <DocumentSnapshot>[];
          final expiredBookings = <DocumentSnapshot>[];
          final now = DateTime.now();

          for (final doc in streamSnapshot.data!.docs) {
            final DateTime eventDate = (doc['date'] as Timestamp).toDate();
            final String status = doc['status'];

            if (status == 'active' && eventDate.isBefore(now)) {
              activeBookings.add(doc);
            } else if (status == 'pending') {
              pendingBookings.add(doc);
            } else if (status == 'cancelled' ||
                status == 'expired' ||
                status == 'rejected') {
              expiredBookings.add(doc);
            }
          }

          return ListView.builder(
            itemCount: activeBookings.length +
                pendingBookings.length +
                expiredBookings.length +
                3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Active Bookings',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  ),
                );
              } else if (index <= activeBookings.length) {
                final doc = activeBookings[index - 1];
                return buildBookingCard1(
                    context, doc, Colors.deepPurpleAccent, Colors.pinkAccent);
              } else if (index == activeBookings.length + 1) {
                return const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Request Bookings',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  ),
                );
              } else if (index > activeBookings.length + 1 &&
                  index <= pendingBookings.length + activeBookings.length + 1) {
                final doc = pendingBookings[index - activeBookings.length - 2];
                return buildBookingCard2(
                    context, doc, Colors.lightBlue, Colors.pinkAccent);
              } else if (index <=
                  (activeBookings.length + pendingBookings.length + 2)) {
                return const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Cancelled Bookings',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  ),
                );
              } else {
                final doc = expiredBookings[
                    index - activeBookings.length - pendingBookings.length - 3];
                return buildBookingCard3(
                    context, doc, Colors.blue, Colors.pink);
              }
            },
          );
        },
      ),
    );
  }

  Widget buildBookingCard1(BuildContext context,
      DocumentSnapshot documentSnapshot, Color startColor, Color endColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: GestureDetector(
        onTap: () async {
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          DocumentReference userDocRef =
              firestore.collection('bookings').doc(documentSnapshot.id);
          CollectionReference ordersCollectionRef =
              userDocRef.collection('service');

          QuerySnapshot querySnapshot = await ordersCollectionRef.get();

          if (querySnapshot.docs.length > 0) {
            Map<String, dynamic> service = {};

            querySnapshot.docs.forEach((orderDoc) {
              service = orderDoc.data() as Map<String, dynamic>;
            });

            List<Widget> listItems = [];

            service.forEach((key, value) {
              listItems.add(
                ListTile(
                  title: Text(key),
                  subtitle: Text(value.toString()),
                ),
              );
            });
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
                          "${documentSnapshot['name']}",
                        ),
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: 100,
                            minWidth: 400,
                            maxHeight: 550,
                            maxWidth: 500),
                        height: 300,
                        width: 450,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              if (documentSnapshot['pdf'] != null)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      generateQRCode(documentSnapshot['pdf']),
                                    ]),
                              Text(
                                "Event Date : ${DateFormat.yMd().format(documentSnapshot['eventDate'].toDate())}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Booking Date : ${DateFormat.yMd().format(documentSnapshot['date'].toDate())}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Total Amount : ${documentSnapshot['paymentAmount']}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              if (service.length > 0)
                                Text(
                                  "Services : ",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              if (service.length > 0)
                                Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Container(
                                    color: Colors.black12.withOpacity(0.2),
                                    child: LimitedBox(
                                      maxHeight: 200,
                                      child: ListView(
                                        children: listItems,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          }
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [startColor.withOpacity(0.9), endColor.withOpacity(0.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 18,
            child: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                        child: Text(
                          documentSnapshot['name'],
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Text(
                          DateFormat.yMd()
                              .format(documentSnapshot['date'].toDate()),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black87,
                    height: 0.1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      color: Colors.transparent,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (documentSnapshot['eventDate'].toDate().isAfter(
                              DateTime.now().add(const Duration(days: 7)))) {
                            String bookingId = documentSnapshot.id;

                            try {
                              cancelInformationAlert(
                                  context, 'Are you Confirm cancel', bookingId);
                            } catch (error) {
                              print('Error deleting booking: $error');
                            }
                          } else {
                            String bookingId = documentSnapshot.id;
                            cancelInformationAlert(
                                context,
                                'You are not eligible to get a full refund',
                                bookingId);
                          }
                        },
                        child: const Text('Cancel'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBookingCard2(BuildContext context,
      DocumentSnapshot documentSnapshot, Color startColor, Color endColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: GestureDetector(
        onTap: () async {
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          DocumentReference userDocRef =
              firestore.collection('bookings').doc(documentSnapshot.id);
          CollectionReference ordersCollectionRef =
              userDocRef.collection('service');

          QuerySnapshot querySnapshot = await ordersCollectionRef.get();

          if (querySnapshot.docs.length > 0) {
            Map<String, dynamic> service = {};

            querySnapshot.docs.forEach((orderDoc) {
              service = orderDoc.data() as Map<String, dynamic>;
            });

            List<Widget> listItems = [];
            service.forEach((key, value) {
              listItems.add(
                ListTile(
                  title: Text(key),
                  subtitle: Text(value.toString()),
                ),
              );
            });
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    shadowColor: Colors.black,
                    elevation: 8,
                    icon: const Icon(
                      Icons.event,
                      color: Colors.blue,
                      size: 60,
                    ),
                    title: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "${documentSnapshot['name']}",
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Container(
                        color: Colors.white70,
                        constraints: BoxConstraints(
                            minHeight: 100,
                            minWidth: 400,
                            maxHeight: 550,
                            maxWidth: 500),
                        height: 300,
                        width: 450,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              if (documentSnapshot['pdf'] != null)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      generateQRCode(documentSnapshot['pdf']),
                                    ]),
                              Text(
                                "Event Date : ${DateFormat.yMd().format(documentSnapshot['eventDate'].toDate())}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Booking Date : ${DateFormat.yMd().format(documentSnapshot['date'].toDate())}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Total Amount : \$${documentSnapshot['paymentAmount']}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              if (service.length > 0)
                                Text(
                                  "Services : ",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              if (service.length > 0)
                                Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Container(
                                    color: Colors.black12.withOpacity(0.2),
                                    child: LimitedBox(
                                      maxHeight: 250,
                                      child: ListView(
                                        children: listItems,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          }
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [startColor.withOpacity(0.9), endColor.withOpacity(0.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            child: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 8, 0),
                        child: Text(
                          documentSnapshot['name'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      // subtitle: Text('Upcoming on ${documentSnapshot.data[index].date.toString()}'),
                    ),
                  ),
                  Center(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 8, 0),
                        child: Text(
                          DateFormat.yMd()
                              .format(documentSnapshot['date'].toDate()),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      trailing: Text(
                        documentSnapshot['status'],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      color: Colors.transparent,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (documentSnapshot['eventDate'].toDate().isAfter(
                              DateTime.now().add(const Duration(days: 14)))) {
                            String bookingId = documentSnapshot.id;

                            try {
                              cancelInformationAlert(
                                  context, 'Are you Confirm cancel', bookingId);
                            } catch (error) {
                              print('Error deleting booking: $error');
                            }
                          } else {
                            String bookingId = documentSnapshot.id;

                            cancelInformationAlert(
                                context,
                                'You are not eligible to get a full refund',
                                bookingId);
                          }
                        },
                        child: const Text('Cancel'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBookingCard3(BuildContext context,
      DocumentSnapshot documentSnapshot, Color startColor, Color endColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: GestureDetector(
        onTap: () async {
          FirebaseFirestore firestore = await FirebaseFirestore.instance;
          DocumentReference userDocRef =
              await firestore.collection('bookings').doc(documentSnapshot.id);
          CollectionReference ordersCollectionRef =
              await userDocRef.collection('service');

          QuerySnapshot querySnapshot = await ordersCollectionRef.get();

          if (querySnapshot.docs.length > 0) {
            Map<String, dynamic> service = {};
            querySnapshot.docs.forEach((orderDoc) {
              service = orderDoc.data() as Map<String, dynamic>;
            });

            List<Widget> listItems = [];

            service.forEach((key, value) {
              listItems.add(
                ListTile(
                  title: Text(key),
                  subtitle: Text(value.toString()),
                ),
              );
            });
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  try {
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
                            "${documentSnapshot['name']}",
                          ),
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: 100,
                              minWidth: 400,
                              maxHeight: 550,
                              maxWidth: 500),
                          height: 300,
                          width: 450,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                if (documentSnapshot['pdf'] != null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        generateQRCode(documentSnapshot['pdf']),
                                      ]),
                                Text(
                                  "Event Date : ${DateFormat.yMd().format(documentSnapshot['eventDate'].toDate())}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Booking Date : ${DateFormat.yMd().format(documentSnapshot['date'].toDate())}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Total Amount : ${documentSnapshot['paymentAmount']}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                if (service.length > 0)
                                  Text(
                                    "Services : ",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                if (service.length > 0)
                                  Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    child: Container(
                                      color: Colors.black12.withOpacity(0.2),
                                      child: LimitedBox(
                                        maxHeight: 200,
                                        child: ListView(
                                          children: listItems,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      actions: [
                        if (documentSnapshot['isRated'] == false)
                          TextButton(
                            child: const Text('FeedBack',
                                style: TextStyle(fontSize: 16)),
                            onPressed: () async {
                              await getPackage(documentSnapshot['name'],
                                  documentSnapshot.id);
                              Navigation(
                                  context,
                                  CustomRatingBar(
                                    onRatingChanged: (double) {},
                                    pid: packageId,
                                    bid: bookingId,
                                  ));
                            },
                          ),
                        if (documentSnapshot['isRated'] == true)
                          TextButton(
                            child: const Text('FeedBack',
                                style: TextStyle(fontSize: 16)),
                            onPressed: () {
                              showToast("Already received feedback.");
                            },
                          ),
                        TextButton(
                          child:
                              const Text('OK', style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  } catch (e) {
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
                            "${documentSnapshot['name']}",
                          ),
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: 100,
                              minWidth: 400,
                              maxHeight: 550,
                              maxWidth: 500),
                          height: 300,
                          width: 450,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                if (documentSnapshot['pdf'] != null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        generateQRCode(documentSnapshot['pdf']),
                                      ]),
                                Text(
                                  "Booking Date : ${DateFormat.yMd().format(documentSnapshot['date'].toDate())}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Total Amount : ${documentSnapshot['paymentAmount']}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                if (service.length > 0)
                                  Text(
                                    "Services : ",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                if (service.length > 0)
                                  Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    child: Container(
                                      color: Colors.black12.withOpacity(0.2),
                                      child: LimitedBox(
                                        maxHeight: 200,
                                        child: ListView(
                                          children: listItems,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      actions: [
                        TextButton(
                          child:
                              const Text('OK', style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  }
                });
          }
        },
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [startColor.withOpacity(0.8), endColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            child: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 8, 0),
                        child: Text(
                          documentSnapshot['name'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      // subtitle: Text('Upcoming on ${documentSnapshot.data[index].date.toString()}'),
                    ),
                  ),
                  Center(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 8, 0),
                        child: Text(
                          DateFormat.yMd()
                              .format(documentSnapshot['date'].toDate()),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      trailing: Text(
                        documentSnapshot['status'],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
