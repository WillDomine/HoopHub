import 'package:flutter/material.dart';

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
        print(uid);
      },
    );
  }
}
