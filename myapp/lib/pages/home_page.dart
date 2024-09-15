import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/all.dart';

String capitilize(String text) {
  if (text.isEmpty) {
    return text;
  }
  String result = text[0].toUpperCase() + text.substring(1);
  return result;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Hoop Hub"),
          centerTitle: true,
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
              });
            },
            decoration: const InputDecoration(
                labelText: "Search Player", prefixIcon: Icon(Icons.search)),
          ),
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('playerslist')
                      .orderBy('player')
                      .limit(10)
                      .startAt([capitilize(_searchText)]).endAt(
                          [capitilize(_searchText) + '\uf8ff']).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No data found"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length > 10
                            ? 10
                            : snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          return PlayerListTile(
                            title: Text(doc['player']),
                            subtitle: Text(doc['tm']),
                            uid: doc.reference.id,
                          );
                        });
                  }))
        ]),
      ),
    );
  }
}
