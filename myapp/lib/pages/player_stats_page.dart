import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:myapp/all.dart';

class PlayerStatsPage extends StatefulWidget {
  final String playerName;
  final String firstSeason;
  final String lastSeason;

  const PlayerStatsPage(
      {super.key,
      required this.playerName,
      required this.firstSeason,
      required this.lastSeason});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  int season = 0;
  List<DropdownMenuItem> seasons = [];

  Map<String, dynamic> playerData = {};

  bool? saved;

  void checkIfSaved(String playerId) async {
    RealTimeDB.read(Auth().currentUser!.uid).then((value) {
      print(value);
      if (value != null && value[playerId] != null) {
        setState(() {
          saved = true;
        });
      } else {
        setState(() {
          saved = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    season = int.parse(widget.lastSeason);

    for (int i = int.parse(widget.firstSeason);
        i <= int.parse(widget.lastSeason);
        i++) {
      seasons.add(DropdownMenuItem(value: i, child: Text(i.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playerName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                saved ?? false
                    ? RealTimeDB.delete(Auth().currentUser!.uid,
                        playerData['playerId'].toString())
                    : RealTimeDB.update(Auth().currentUser!.uid, {
                        playerData['playerId'].toString():
                            playerData['playerId']
                      });

                setState(() {
                  saved ?? false ? saved = false : saved = true;
                });
              },
              icon: Icon(saved ?? false ? Icons.star : Icons.star_border)),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('PlayerSeasonStats')
                      .where('name', isEqualTo: widget.playerName)
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

                    checkIfSaved(playerData['playerId'].toString());

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        return PlayerStatTile(
                            statName:
                                playerData.keys.toList()[index].substring(0, 3),
                            statValue:
                                playerData.values.toList()[index].toString());
                      },
                      itemCount: playerData.keys.length,
                      shrinkWrap: true,
                    );
                  }),
            ],
          )),
    );
  }
}
