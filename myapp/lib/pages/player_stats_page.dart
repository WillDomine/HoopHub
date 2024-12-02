import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/models/player_model_tile.dart';
import 'package:myapp/methods.dart';
import 'package:myapp/models/player_model_profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerStatsPage extends StatefulWidget {
  final PlayerModelTile player;
  final String selectedSeason;

  const PlayerStatsPage(
      {super.key, required this.player, required this.selectedSeason});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  List<PlayerModelProfile> playerData = [];

  String? selectedSeason;

  bool allStar = false;

  bool hof = false;

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
    //Check if player is a hall of famer
    Supabase.instance.client.rpc('search_if_hof',
        params: {'pid': widget.player.playerId}).then((value) {
      setState(() {
        hof = value;
      });
    });
    //Check if player is saved or not
    checkIfSaved().then((value) {
      saved = value;
    });
    //Get player data
    Supabase.instance.client
        .from('player_year_stats')
        .select('*')
        .eq('player_id', widget.player.playerId)
        .then((value) {
      playerData = value.map((e) => PlayerModelProfile.fromJson(e)).toList();
      setState(() {
        playerData = playerData.reversed.toList();
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
            hof
                ? const Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    message: 'Hall of Fame',
                    child: FaIcon(FontAwesomeIcons.crown, color: Colors.amber),
                  )
                : const SizedBox(),
            const SizedBox(width: 20),
            Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: 'All Star',
                child: Icon(
                  allStar ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                )),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message: saved ?? false ? 'Unsave' : 'Save',
              child: IconButton(
                  icon: Icon(
                      saved ?? false ? Icons.bookmark : Icons.bookmark_border),
                  onPressed: () {
                    setState(() {
                      saved! ? deletePlayer() : savePlayer();
                    });
                  }),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Methods.getPlayerImage(widget.player.playerName),
              ),
              const Divider(height: 20, thickness: 2.0),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: playerData.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                          collapsedTextColor: Colors.grey,
                          initiallyExpanded: selectedSeason ==
                              playerData[index].season.toString(),
                          leading: Methods.getTeamImage(playerData[index].team),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Season: ${playerData[index].season}'),
                              Text('Games: ${playerData[index].games}'),
                            ],
                          ),
                          children: [
                            Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                'FG: ${playerData[index].fgPercent}'),
                                            Text(
                                                '3PT: ${playerData[index].x3Percent}'),
                                            Text(
                                                'FT: ${playerData[index].ftPercent}'),
                                          ])
                                    ])))
                          ]);
                    }),
              )
            ]),
          ),
        ));
  }
}
