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

  String searchPlayer = '';

  String? teamSelectedValue;

  String? seasonSelectedValue;

  void teamChanged(String? value) {
    setState(() {
      teamSelectedValue = value;
    });
  }

  void seasonChanged(String? value) {
    setState(() {
      seasonSelectedValue = value;
    });
  }

  List<DropdownMenuItem<String>> teamsDropdownItems = [];
  List<DropdownMenuItem<String>> seasonsDropdownItems = [];

  void createSeasonDropdown() {
    var firstSeason = 1947;
    var lastSeason = DateTime.now().year + 1;

    for (var i = lastSeason; i >= firstSeason; i--) {
      seasonsDropdownItems.add(DropdownMenuItem(
        value: i.toString(),
        child: Text(i.toString()),
      ));
    }

    seasonsDropdownItems.insert(
        0,
        const DropdownMenuItem(
          value: '',
          child: Text('All Seasons'),
        ));

    setState(() {
      seasonSelectedValue = seasonsDropdownItems[0].value;
    });
  }

  void createTeamDropdown() {
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
        teamSelectedValue = teamsDropdownItems[0].value;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    createTeamDropdown();
    createSeasonDropdown();
  }

  Widget searchPlayerTab() {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
                          searchPlayer = value;
                        });
                      },
                      controller: searchController,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search by player name',
                      ),
                    ),
                    leading: Icon(Icons.search),
                  ),
                  const Divider(height: 20, thickness: 2.0),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    DropdownButton(
                        menuMaxHeight: 250,
                        underline: const SizedBox(),
                        icon: const SizedBox(),
                        items: teamsDropdownItems,
                        onChanged: teamChanged,
                        value: teamSelectedValue),
                    const Spacer(),
                    DropdownButton(
                        menuMaxHeight: 250,
                        underline: const SizedBox(),
                        icon: const SizedBox(),
                        items: seasonsDropdownItems,
                        onChanged: seasonChanged,
                        value: seasonSelectedValue),
                  ]),
                  const Divider(height: 20, thickness: 2.0),
                  StreamBuilder(
                      stream: Supabase.instance.client
                          .rpc('search_player', params: {
                            'player_search': searchPlayer,
                            'player_year': seasonSelectedValue,
                            'player_team': teamSelectedValue
                          })
                          .limit(seasonSelectedValue == '' &&
                                  teamSelectedValue == ''
                              ? 10
                              : 100)
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
                            var nameSplit =
                                player['player'].toString().split(' ');
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
                                  leading: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Image.network(Supabase
                                          .instance.client.storage
                                          .from('player_images')
                                          .getPublicUrl(
                                            '${capitalize(nameSplit[0])}_${nameSplit[1]}.png',
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
