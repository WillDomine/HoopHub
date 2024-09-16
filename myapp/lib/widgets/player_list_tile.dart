import 'package:flutter/material.dart';
import 'package:myapp/pages/player_stats_page.dart';

class PlayerListTile extends ListTile {
  final uid;

  const PlayerListTile({
    super.key,
    required super.title,
    required super.subtitle,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PlayerStatsPage(uid: uid)));
      },
    );
  }
}
