import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:myapp/all.dart';

class PlayerStatsPage extends StatefulWidget {
  final String uid;

  const PlayerStatsPage({super.key, required this.uid});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('playerslist')
        .doc(widget.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        data = documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['player'] ?? ''),
        centerTitle: true,
      ),
    );
  }
}
