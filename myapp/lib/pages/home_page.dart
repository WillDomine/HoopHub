import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/pages/player_stats_page.dart';
import 'package:myapp/models/player_model_tile.dart';
import 'package:myapp/methods.dart';
import 'package:myapp/pages/user_page.dart';

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

  /// Generates a list of [DropdownMenuItem]s for the season dropdown menu.
  ///
  /// The list starts with a "All Seasons" item and then contains each year
  /// from the current year down to 1947. The list is sorted in descending
  /// order.
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

  /// Generates a list of [DropdownMenuItem]s for the team dropdown menu.
  ///
  /// The list starts with a "All Teams" item and then contains each team's
  /// abbreviation in the 2025 season. The list is sorted in ascending order
  /// by team abbreviation.
  ///
  /// When the list is generated, the selected team is set to the first item
  /// in the list.
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
                    leading: const Icon(Icons.search),
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
                          .limit((seasonSelectedValue == '' &&
                                  teamSelectedValue == '')
                              ? 10
                              : 30)
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

                        List<PlayerModelTile> players = [];
                        for (var player in snapshot.data!) {
                          players.add(PlayerModelTile.fromJson(player));
                        }

                        return ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            var player = players[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  onTap: () {
                                    Supabase.instance.client
                                        .from('players')
                                        .update({
                                          'times_clicked':
                                              player.timesClicked + 1
                                        })
                                        .eq('player_id', player.playerId)
                                        .ignore();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayerStatsPage(
                                            player: player,
                                            selectedSeason:
                                                seasonSelectedValue as String,
                                          ),
                                        ));
                                  },
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 40,
                                      child: Methods.getPlayerImage(
                                          player.playerName)),
                                  title: Text(player.playerName),
                                  subtitle: Text(
                                      '${player.firstSeason} - ${player.lastSeason}'),
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
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserPage(),
                  ));
            },
          ),
        ],
      ),
      body: searchPlayerTab(),
    );
  }
}
