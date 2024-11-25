import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/models/player_model_tile.dart';
import 'package:myapp/methods.dart';

class PlayerStatsPage extends StatefulWidget {
  final PlayerTile player;
  final String selectedSeason;

  const PlayerStatsPage(
      {super.key, required this.player, required this.selectedSeason});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  Map<String, dynamic> playerData = {};

  String? selectedSeason;

  bool allStar = false;

  bool? saved;
  @override
  void initState() {
    super.initState();
    //Set selected season to last season if no season is selected
    widget.selectedSeason == ''
        ? selectedSeason = widget.player.lastSeason.toString()
        : selectedSeason = widget.selectedSeason;
    //Check if player is an all star
    Supabase.instance.client.rpc('search_if_allstar',
        params: {'player_name': widget.player.playerName}).then((value) {
      setState(() {
        allStar = value > 0 ? true : false;
      });
    });
    //
    checkIfSaved().then((value) {
      saved = value;
    });
    //Get player data
    Stream stream = Supabase.instance.client
        .from('player_stats')
        .select('*')
        .eq('player', widget.player.playerName)
        .eq('season', selectedSeason as Object)
        .asStream();

    stream.listen((event) {
      setState(() {
        playerData = event[0];
      });
    });
  }

  Future<bool> checkIfSaved() async {
    var data =
        await Supabase.instance.client.from('saved_players').select('*').match({
      'player_id': widget.player.playerId,
    });
    return data.isEmpty ? false : true;
  }

  Future<void> deletePlayer() async {
    await Supabase.instance.client.from('saved_players').delete().match({
      'player_id': widget.player.playerId,
    }).then((value) {
      checkIfSaved().then((value) {
        setState(() {
          saved = value;
        });
      });
    });
  }

  Future<void> savePlayer() async {
    await Supabase.instance.client.from('saved_players').insert({
      'player_id': widget.player.playerId,
      'user_id': Supabase.instance.client.auth.currentUser!.id
    }).then((value) {
      checkIfSaved().then((value) {
        setState(() {
          saved = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var nameSplit = widget.player.playerName.split(' ');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.player.playerName,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {
                  if (saved == null) {
                    return;
                  }
                  saved ?? false ? deletePlayer() : savePlayer();
                },
                icon: Icon(saved ?? false ? Icons.star : Icons.star_border))
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Methods.getPlayerImage(nameSplit),
              ),
              const Divider(height: 20, thickness: 2.0),
            ]),
          ),
        ));
  }
}
