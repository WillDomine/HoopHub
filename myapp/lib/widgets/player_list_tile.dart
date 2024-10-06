import 'package:flutter/material.dart';
import 'package:myapp/pages/player_stats_page.dart';
import 'package:myapp/models/player_model.dart';

class PlayerListTile extends ListTile {
  final Player player;

  const PlayerListTile({
    super.key,
    required super.title,
    required super.subtitle,
    required this.player,
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
                      player: player,
                    )));
      },
    );
  }
}
