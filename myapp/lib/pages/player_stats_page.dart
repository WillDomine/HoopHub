import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/all.dart';

//
// PlayerStatsPage Class StatefulWidget
// Used to display player stats on player profile page
//
class PlayerStatsPage extends StatefulWidget {
  final Player player;

  const PlayerStatsPage({super.key, required this.player});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  // The season the user is currently viewing
  int season = 0;

  // List of seasons to be displayed
  List<DropdownMenuItem> seasons = [];

  // The player's data to be displayed
  Map<String, dynamic> playerData = {};

  // Whether the player is saved or not
  bool saved = false;

  @override
  void initState() {
    super.initState();
    // Set the season and seasons to be displayed
    season = int.parse(widget.player.firstSeason);

    // Get the seasons
    for (int i = int.parse(widget.player.firstSeason);
        i <= int.parse(widget.player.lastSeason);
        i++) {
      seasons.add(DropdownMenuItem(value: i, child: Text(i.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.player.name),
          centerTitle: true,
          actions: [
            // Save button
            IconButton(
                onPressed: () {
                  setState(() {
                    saved ? saved = false : saved = true;
                  });
                },
                icon: Icon(saved ? Icons.star : Icons.star_border)),
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Season dropdown menu
                DropdownButton(
                    borderRadius: BorderRadius.circular(10.0),
                    underline: const SizedBox(),
                    value: season,
                    items: seasons,
                    onChanged: (value) {
                      setState(() {
                        season = value!;
                      });
                    }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              // Display the player's data
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('PlayerSeasonStats')
                      .where('name', isEqualTo: widget.player.name)
                      .where('season', isEqualTo: season)
                      .limit(1)
                      .get()
                      .then((value) {
                    return value.docs[0].data();
                  }),
                  builder:
                      (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    playerData = snapshot.data!;

                    return Text(playerData.toString());
                  }),
            )
          ],
        ));
  }
}
