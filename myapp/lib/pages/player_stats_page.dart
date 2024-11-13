import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/methods.dart';

class PlayerStatsPage extends StatefulWidget {
  final Player player;
  final String selectedSeason;

  const PlayerStatsPage(
      {super.key, required this.player, required this.selectedSeason});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  Map<String, dynamic> playerData = {};

  String? selectedSeason;

  bool all_star = false;

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
        all_star = value > 0 ? true : false;
      });
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

  @override
  Widget build(BuildContext context) {
    var nameSplit = widget.player.playerName.split(' ');
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.player.playerName),
          centerTitle: false,
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
            ]),
          ),
        ));
  }
}
