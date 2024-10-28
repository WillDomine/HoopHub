import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/all.dart';

/// Capitalize the first letter of a given string and return the result.
///
/// If the given string is empty, return the same string.
///
/// Example:
///   capitilize('hello') // 'Hello'
String capitilize(String text) {
  if (text.isEmpty) {
    return text;
  }
  String result = text[0].toUpperCase() + text.substring(1);
  return result;
}

//
// HomePage Class StatefulWidget
// Used to search for players based on name
//
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Text field controller, but easier to monitor then TextEditingController, may change later to TextFieldController
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      UserData.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Hoop Hub"),
          centerTitle: true,

          //IconButton to go to ProfilePage
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
              icon: const Icon(Icons.person)),
          actions: [
            //IconButton to go to SettingsPage
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const SizedBox(height: 20.0),

          //Search Bar to search for players
          TextField(
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            decoration: const InputDecoration(
                labelText: "Search Player", prefixIcon: Icon(Icons.search)),
          ),

          //List of players certain amount displayed based on the length of the search text
          Expanded(
              //Used to query the players from the database
              child: StreamBuilder(
                  //If the search text is longer than 2 characters query 5 if greater than 3 characters query 3
                  stream: _searchText.length > 2
                      ? FirebaseFirestore.instance
                          .collection('playerinfo')
                          .orderBy('name')
                          .limit(_searchText.length > 3 ? 3 : 5)
                          .startAt([capitilize(_searchText)]).endAt(
                              ['${capitilize(_searchText)}\uf8ff']).snapshots()
                      //If the search text is less than 3 characters query 10 players based on name order !Idea add cashing and timesclicked to database!
                      : FirebaseFirestore.instance
                          .collection('playerinfo')
                          .orderBy('name')
                          .limit(10)
                          .snapshots(),
                  builder: (context, snapshot) {
                    //Used if there is no data in the query
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    //Used ListView.builder to display the players from StreamBuilder
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length > 10
                            ? 10
                            : snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          return PlayerListTile(
                            title: Text(doc['name']),
                            subtitle: Text(
                                "${doc['firstSeason']} - ${doc['lastSeason']}"),
                            player: Player(
                                doc['name'],
                                doc['firstSeason'].toString(),
                                doc['lastSeason'].toString(),
                                doc.id),
                          );
                        });
                  }))
        ]),
      ),
    );
  }
}
