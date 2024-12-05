import 'package:flutter/material.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/models/player_model_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/pages/player_stats_page.dart';
import 'package:myapp/methods.dart';

import 'entry_portal_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<PlayerModelTile> savedPlayers = [];
  @override
  void initState() {
    super.initState();

    Supabase.instance.client
        .from('saved_players')
        .select('*')
        .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
        .then((value) {
      for (var player in value) {
        Supabase.instance.client
            .from('players')
            .select('*')
            .eq('player_id', player['player_id'])
            .then((value2) {
          setState(() {
            savedPlayers.add(PlayerModelTile.fromJson(value2.first));
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Players'),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {
                  AuthService.signOut().then((value) {
                    if (value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EntryPortal(),
                          ));
                    }
                  });
                },
                icon: const Icon(Icons.logout)),
            IconButton(
                icon: Icon(false ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  print(savedPlayers);
                }),
          ],
        ),
        body: Scaffold(
            body: Center(
          child: savedPlayers.isEmpty
              ? const Text('No saved players')
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          onTap: () {
                            Supabase.instance.client
                                .from('players')
                                .update({
                                  'times_clicked':
                                      savedPlayers[index].timesClicked + 1
                                })
                                .eq('player_id', savedPlayers[index].playerId)
                                .ignore();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayerStatsPage(
                                    player: savedPlayers[index],
                                    selectedSeason: savedPlayers[index]
                                        .lastSeason
                                        .toString(),
                                  ),
                                ));
                          },
                          leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 40,
                              child: Methods.getPlayerImage(
                                  savedPlayers[index].playerName)),
                          title: Text(savedPlayers[index].playerName),
                          subtitle: Text(
                              '${savedPlayers[index].firstSeason} - ${savedPlayers[index].lastSeason}'),
                        ),
                      ),
                    );
                  },
                  itemCount: savedPlayers.length),
        )));
  }
}
