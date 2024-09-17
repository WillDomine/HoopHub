import 'package:flutter/material.dart';

class PlayerStatTile extends ListTile {
  final String statName;
  final String statValue;

  const PlayerStatTile({
    super.key,
    required this.statName,
    required this.statValue,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(statName),
      subtitle: Text(statValue),
    );
  }
}
