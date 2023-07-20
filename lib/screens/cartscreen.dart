import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddToCartScreen extends StatelessWidget {
  AddToCartScreen({super.key});
  final _cart = FirebaseFirestore.instance.collection("carts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _cart.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      color: Color.fromARGB(100, 260, 250, 254),
                      child: ListTile(
                        title: Text(
                          documentSnapshot['name'],
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          'Rs.' + documentSnapshot['price'].toString() + '.00',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
