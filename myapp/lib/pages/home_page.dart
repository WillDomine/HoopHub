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
                  const Divider(height: 20, thickness: 2.0),
                  StreamBuilder(
                      stream: Supabase.instance.client
                          .from('players')
                          .select('*')
                          .ilike('player', '%${searchController.text}%')
                          .order('time_clicked', ascending: false)
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
                                      'time_clicked': player['time_clicked'] + 1
                                    }).eq('player', player['player']);
                                  },
                                  leading: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Image.network(Supabase
                                          .instance.client.storage
                                          .from('player_images')
                                          .getPublicUrl(
                                            'lebron.jpg',
                                          ))),
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
                if (await AuthService.isSignedIn()) {
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
