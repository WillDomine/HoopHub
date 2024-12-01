import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/models/player_model_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
          title: const Text('User Page'),
          centerTitle: false,
          actions: [
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
                    return ListTile(
                      title: Text(savedPlayers[index].playerName),
                    );
                  },
                  itemCount: savedPlayers.length),
        )));
  }
}
