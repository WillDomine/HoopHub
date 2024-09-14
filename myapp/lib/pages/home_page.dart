import 'package:flutter/material.dart';
import 'package:myapp/all.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _amountInList = 0;

  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Home page"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
              icon: const Icon(Icons.person)),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const SizedBox(height: 20.0),
          TextField(
            onChanged: (value) {
              setState(() {
                _searchText = value;
                value.length > 2 ? _amountInList = 10 : _amountInList = 0;
              });
            },
            decoration: const InputDecoration(
                labelText: "Search Player", prefixIcon: Icon(Icons.search)),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _amountInList,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_searchText),
                  );
                }),
          )
        ]),
      ),
    );
  }
}
