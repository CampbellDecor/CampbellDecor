import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = List.generate(10, (index) => 'Item $index');

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      items = List.generate(10, (index) => 'Refreshed Item $index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swipe to Refresh'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
        ),
      ),
    );
  }
}
