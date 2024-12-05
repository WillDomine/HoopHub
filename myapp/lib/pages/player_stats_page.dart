import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/models/player_model_tile.dart';
import 'package:myapp/methods.dart';
import 'package:myapp/models/player_model_profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:myapp/radar_chart_max_min.dart';
import 'package:fl_chart/fl_chart.dart';

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

  ItemScrollController itemScrollController = ItemScrollController();
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
    if (playerData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    Future.delayed(const Duration(seconds: 2), () {
      itemScrollController.scrollTo(
          index: playerData.indexWhere(
              (element) => element.season == int.parse(selectedSeason ?? '0')),
          duration: const Duration(seconds: 1));
    });

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
                child: ScrollablePositionedList.builder(
                    itemScrollController: itemScrollController,
                    shrinkWrap: true,
                    itemCount: playerData.length,
                    itemBuilder: (context, index) {
                      if (playerData[index].fgPercent == 'NA') {
                        playerData[index].fgPercent = '0';
                      }
                      double fgPercentage =
                          double.parse(playerData[index].fgPercent);
                      if (playerData[index].x3Percent == 'NA') {
                        playerData[index].x3Percent = '0';
                      }
                      double x3Percentage =
                          double.parse(playerData[index].x3Percent);
                      if (playerData[index].ftPercent == 'NA') {
                        playerData[index].ftPercent = '0';
                      }
                      double ftPercentage =
                          double.parse(playerData[index].ftPercent);
                      double efgPercentage = (fgPercentage + x3Percentage) / 2;
                      List<String> dataSetTitles = [
                        'FG%-${fgPercentage.isNaN ? 0 : (fgPercentage * 100).toStringAsFixed(2)}%',
                        '3P%-${x3Percentage.isNaN ? 0 : (x3Percentage * 100).toStringAsFixed(2)}%',
                        'FT%-${ftPercentage.isNaN ? 0 : (ftPercentage * 100).toStringAsFixed(2)}%',
                        'eFG%-${efgPercentage.isNaN ? 0 : (efgPercentage * 100).toStringAsFixed(2)}%',
                      ];
                      RadarDataSet dataSet = RadarDataSet(dataEntries: [
                        RadarEntry(
                            value: fgPercentage.isNaN ? 0 : fgPercentage * 100),
                        RadarEntry(
                            value: x3Percentage.isNaN ? 0 : x3Percentage * 100),
                        RadarEntry(
                          value: ftPercentage.isNaN ? 0 : ftPercentage * 100,
                        ),
                        RadarEntry(
                            value: (efgPercentage.isNaN
                                ? 0
                                : efgPercentage * 100)),
                      ]);

                      RadarChartDataFixMinMax radarChartDataFixMinMax =
                          RadarChartDataFixMinMax(
                        max: const RadarEntry(value: 100),
                        min: const RadarEntry(value: 20),
                        dataSets: [dataSet],
                        getTitle: (index, _) =>
                            RadarChartTitle(text: dataSetTitles[index]),
                        tickCount: 4,
                        radarBorderData:
                            BorderSide(color: Theme.of(context).hintColor),
                        radarShape: RadarShape.polygon,
                        radarBackgroundColor: Colors.transparent,
                        ticksTextStyle: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 8),
                        tickBorderData:
                            BorderSide(color: Theme.of(context).hintColor),
                        gridBorderData:
                            BorderSide(color: Theme.of(context).hintColor),
                        titlePositionPercentageOffset: 0.45,
                        titleTextStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      );

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
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              'Points Per Game: ${playerData[index].ptsPerGame}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                      const Divider(height: 20, thickness: 2.0),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: RadarChart(
                                          radarChartDataFixMinMax,
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      const Divider(
                                        thickness: 2.0,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Tooltip(
                                              triggerMode:
                                                  TooltipTriggerMode.tap,
                                              message: 'Assists per game',
                                              child: Text(
                                                  'APG: ${playerData[index].astPerGame}'),
                                            ),
                                            Tooltip(
                                              triggerMode:
                                                  TooltipTriggerMode.tap,
                                              message: 'Rebounds per game',
                                              child: Text(
                                                  'RPG: ${playerData[index].rebPerGame}'),
                                            ),
                                            Tooltip(
                                              triggerMode:
                                                  TooltipTriggerMode.tap,
                                              message: 'Steals per game',
                                              child: Text(
                                                  'SPG: ${playerData[index].stlPerGame}'),
                                            ),
                                            Tooltip(
                                              triggerMode:
                                                  TooltipTriggerMode.tap,
                                              message: 'Blocks per game',
                                              child: Text(
                                                  'BPG: ${playerData[index].blkPerGame}'),
                                            ),
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
