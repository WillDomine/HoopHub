import 'package:flutter/material.dart';
import 'package:myapp/managers/comparing_manager.dart';
import 'package:myapp/managers/methods.dart';
import 'package:myapp/models/player_model_profile.dart';
import 'package:myapp/radar_chart_max_min.dart';
import 'package:fl_chart/fl_chart.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  ComparingManager comparingManager = ComparingManager();

  Widget playerSlot(PlayerModelProfile player) {
    bool pts = false;
    bool fg = false;
    bool threep = false;
    bool ft = false;
    bool ast = false;
    bool reb = false;
    bool stl = false;
    bool blk = false;

    if (comparingManager.checkIfBothPlayersSelected()) {
      bool isPlayer1 = player == comparingManager.player1! ? true : false;
      if (isPlayer1) {
        pts = player.ptsPerGame > comparingManager.player2!.ptsPerGame;
        fg = double.parse(player.fgPercent) >
            double.parse(comparingManager.player2!.fgPercent);
        threep = double.parse(player.x3Percent) >
            double.parse(comparingManager.player2!.x3Percent);
        ft = double.parse(player.ftPercent) >
            double.parse(comparingManager.player2!.ftPercent);
        ast = double.parse(player.astPerGame) >
            double.parse(comparingManager.player2!.astPerGame);
        reb = double.parse(player.rebPerGame) >
            double.parse(comparingManager.player2!.rebPerGame);
        stl = double.parse(player.stlPerGame) >
            double.parse(comparingManager.player2!.stlPerGame);
        blk = double.parse(player.blkPerGame) >
            double.parse(comparingManager.player2!.blkPerGame);
      } else {
        pts = player.ptsPerGame > comparingManager.player1!.ptsPerGame;
        fg = double.parse(player.fgPercent) >
            double.parse(comparingManager.player1!.fgPercent);
        threep = double.parse(player.x3Percent) >
            double.parse(comparingManager.player1!.x3Percent);
        ft = double.parse(player.ftPercent) >
            double.parse(comparingManager.player1!.ftPercent);
        ast = double.parse(player.astPerGame) >
            double.parse(comparingManager.player1!.astPerGame);
        reb = double.parse(player.rebPerGame) >
            double.parse(comparingManager.player1!.rebPerGame);
        stl = double.parse(player.stlPerGame) >
            double.parse(comparingManager.player1!.stlPerGame);
        blk = double.parse(player.blkPerGame) >
            double.parse(comparingManager.player1!.blkPerGame);
      }
    }

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Column(
        children: [
          Text(
            player.playerName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 150,
            width: 150,
            child: Methods.getPlayerImage(player.playerName),
          ),
          Text(
            player.season.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(
            thickness: 2.0,
          ),
        ],
      ),
      Column(children: [
        Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: 'Points per game',
            child: Text(
              'PPG: ${player.ptsPerGame}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: comparingManager.checkIfBothPlayersSelected()
                      ? pts
                          ? Colors.green
                          : Colors.red
                      : Colors.white),
            )),
        const Divider(thickness: 2.0),
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: 'Field goal percentage',
          child: Text(
            'FG%: ${double.parse(player.fgPercent).toStringAsFixed(2)}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: comparingManager.checkIfBothPlayersSelected()
                    ? fg
                        ? Colors.green
                        : Colors.red
                    : Colors.white),
          ),
        ),
        const Divider(thickness: 2.0),
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: 'Three point percentage',
          child: Text(
            '3P%: ${double.parse(player.x3Percent).toStringAsFixed(2)}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: comparingManager.checkIfBothPlayersSelected()
                    ? threep
                        ? Colors.green
                        : Colors.red
                    : Colors.white),
          ),
        ),
        const Divider(thickness: 2.0),
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: 'Free throw percentage',
          child: Text(
            'FT%: ${double.parse(player.ftPercent).toStringAsFixed(2)}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: comparingManager.checkIfBothPlayersSelected()
                    ? ft
                        ? Colors.green
                        : Colors.red
                    : Colors.white),
          ),
        ),
        const Divider(thickness: 2.0),
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: 'Assists per game',
          child: Text(
            'APG: ${player.astPerGame}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: comparingManager.checkIfBothPlayersSelected()
                    ? ast
                        ? Colors.green
                        : Colors.red
                    : Colors.white),
          ),
        ),
        const Divider(thickness: 2.0),
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: 'Rebounds per game',
          child: Text('RPG: ${player.rebPerGame}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: comparingManager.checkIfBothPlayersSelected()
                      ? reb
                          ? Colors.green
                          : Colors.red
                      : Colors.white)),
        ),
        const Divider(thickness: 2.0),
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: 'Steals per game',
          child: Text('SPG: ${player.stlPerGame}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: comparingManager.checkIfBothPlayersSelected()
                      ? stl
                          ? Colors.green
                          : Colors.red
                      : Colors.white)),
        ),
        const Divider(thickness: 2.0),
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: 'Blocks per game',
          child: Text('BPG: ${player.blkPerGame}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: comparingManager.checkIfBothPlayersSelected()
                      ? blk
                          ? Colors.green
                          : Colors.red
                      : Colors.white)),
        ),
        const Divider(thickness: 2.0),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Compare'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    comparingManager.reset();
                  });
                },
                icon: const Icon(Icons.clear))
          ],
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 1,
            child: comparingManager.player1 == null
                ? const Center(child: Text("Slot 1 Empty"))
                : playerSlot(comparingManager.player1!),
          ),
          const VerticalDivider(width: 1),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 1,
            child: comparingManager.player2 == null
                ? const Center(child: Text("Slot 2 Empty"))
                : playerSlot(comparingManager.player2!),
          ),
        ]));
  }
}
