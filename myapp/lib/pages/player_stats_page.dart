import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:myapp/all.dart';

class PlayerStatsPage extends StatefulWidget {
  final Player player;

  const PlayerStatsPage({super.key, required this.player});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  /// The season the user is currently viewing
  int season = 0;
  List<DropdownMenuItem> seasons = [];

  Map<String, dynamic> playerData = {};

  bool? saved;

  @override
  void initState() {
    super.initState();
    season = int.parse(widget.player.firstSeason);

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
            IconButton(
                onPressed: () {
                  /* saved ?? false
                    ? RealTimeDB.delete(Auth().currentUser!.uid,
                        playerData['playerId'].toString())
                    : RealTimeDB.update(Auth().currentUser!.uid, {
                        playerData['playerId'].toString():
                            playerData['playerId']
                      });
                */
                  setState(() {
                    saved ?? false ? saved = false : saved = true;
                  });
                },
                icon: Icon(saved ?? false ? Icons.star : Icons.star_border)),
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
