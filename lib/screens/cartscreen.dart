import 'package:campbelldecor/reusable_widgets/reusable_methods.dart';
import 'package:campbelldecor/screens/checkoutscreen.dart';
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
                      color: Color.fromARGB(100, 260, 250, 254),
                      child: ListTile(
                        onTap: () {
                          Navication(context, CheckOutScreen());
                        },
                        title: Text(documentSnapshot['name'].value.toString()),
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
