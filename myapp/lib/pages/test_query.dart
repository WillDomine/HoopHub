import 'package:flutter/material.dart';
import 'package:myapp/all.dart';

class TestQuery extends StatefulWidget {
  const TestQuery({super.key});

  @override
  State<TestQuery> createState() => _TestQueryState();
}

class _TestQueryState extends State<TestQuery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Query"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Database().addCity("test");
                  },
                  child: const Text("Test"))
            ],
          )),
    );
  }
}
