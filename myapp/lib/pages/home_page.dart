import 'package:flutter/material.dart';
import 'package:myapp/pages/entry_portal.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  String? selectedValue;
  void onChanged(String? value) {
    setState(() {
      selectedValue = value;
    });
  }

  List<DropdownMenuItem<String>> teamsDropdownItems = [];

  @override
  void initState() {
    super.initState();

    Supabase.instance.client
        .from('teams')
        .select('abbreviation')
        .eq('season', '2025')
        .then((value) {
      for (var team in value) {
        teamsDropdownItems.add(DropdownMenuItem(
          value: team['abbreviation'],
          child: Text(team['abbreviation']),
        ));
      }
      teamsDropdownItems.insert(
          0,
          const DropdownMenuItem(
            value: '',
            child: Text('All Teams'),
          ));

      setState(() {
        selectedValue = teamsDropdownItems[0].value;
      });
    });
  }

  Widget searchPlayerTab() {
    return ListView(
      children: [
        Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  ListTile(
                    title: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchController.text = value;
                        });
                      },
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search by player name',
                      ),
                    ),
                    leading: Icon(Icons.search),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    DropdownButton(
                        menuMaxHeight: 250,
                        underline: const SizedBox(),
                        icon: const SizedBox(),
                        items: teamsDropdownItems,
                        onChanged: onChanged,
                        value: selectedValue),
                  ]),
                  const Divider(height: 20, thickness: 2.0),
                  StreamBuilder(
                      stream: Supabase.instance.client
                          .from('players')
                          .select('*')
                          .ilike('player', '%${searchController.text}%')
                          .order('times_clicked', ascending: false)
                          .limit(5)
                          .asStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Text('Database error!');
                        }

                        if (!snapshot.hasData) {
                          return const Text('No data available');
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var player = snapshot.data![index];

                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ListTile(
                                  onTap: () {
                                    Supabase.instance.client
                                        .from('players')
                                        .update({
                                          'times_clicked':
                                              player['times_clicked'] + 1
                                        })
                                        .eq('player_id', player['player_id'])
                                        .ignore();
                                  },
                                  /*leading: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Image.network(Supabase
                                          .instance.client.storage
                                          .from('player_images')
                                          .getPublicUrl(
                                            '${player['player'].toString().split(' ')[0].toLowerCase()}.jpg',
                                          ))),*/
                                  title: Text(player['player']),
                                  subtitle: Text(
                                      '${player['first_seas']} - ${player['last_seas']}'),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ])))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                if (await AuthService.signOut()) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EntryPortal(),
                      ));
                }
              })
        ],
      ),
      body: searchPlayerTab(),
    );
  }
}
