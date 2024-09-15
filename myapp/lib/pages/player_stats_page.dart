import 'package:flutter/material.dart';

import 'package:myapp/all.dart';

class PlayerStatsPage extends StatefulWidget {
  final String uid;

  const PlayerStatsPage({super.key, required this.uid});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
