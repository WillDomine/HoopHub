import 'package:flutter/material.dart';
import 'package:myapp/pages/player_stats_page.dart';

class PlayerListTile extends ListTile {
  final String playerName;
  final String firstSeason;
  final String lastSeason;

  const PlayerListTile({
    super.key,
    required super.title,
    required super.subtitle,
    required this.playerName,
    required this.firstSeason,
    required this.lastSeason,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerStatsPage(
                      playerName: playerName,
                      firstSeason: firstSeason,
                      lastSeason: lastSeason,
                    )));
      },
    );
  }
}
