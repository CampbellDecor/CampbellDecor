import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class AddToCartScreen extends StatelessWidget {
  AddToCartScreen({super.key});
  final _cartref = FirebaseDatabase.instance.ref("carts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Container(
        child: FirebaseAnimatedList(
            query: _cartref,
            itemBuilder: (context, snapshot, animation, index) {
              return Card(
                color: Color.fromARGB(100, 260, 250, 254),
                child: ListTile(
                  title: Text(snapshot.child('name').value.toString()),
                  trailing: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              _cartref.child(snapshot.key!).remove();
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
