import 'package:flutter/material.dart';
import 'package:myapp/models/player_model_profile.dart';

class ComparingManager {
  static final ComparingManager _instance = ComparingManager._internal();

  factory ComparingManager() => _instance;

  ComparingManager._internal();

  PlayerModelProfile? player1, player2;

  AlertDialog choosePlayerSlot(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a player slot'),
      actions: [
        TextButton(
          child: const Text('Player 1'),
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
        TextButton(
          child: const Text('Player 2'),
          onPressed: () {
            Navigator.pop(context, 2);
          },
        ),
      ],
    );
  }

  void reset() {
    player1 = null;
    player2 = null;
  }

  bool checkIfBothPlayersSelected() {
    if (player1 != null && player2 != null) {
      return true;
    }
    return false;
  }

  void setPlayer(PlayerModelProfile player, BuildContext context) {
    if (player1 == player || player2 == player) {
      SnackBar snackBar = const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Player already selected'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    SnackBar snackBarPlayer1 = const SnackBar(
      duration: Duration(seconds: 1),
      content: Text('Player 1 selected'),
    );

    SnackBar snackBarPlayer2 = const SnackBar(
      duration: Duration(seconds: 1),
      content: Text('Player 2 selected'),
    );

    if (player1 == null) {
      player1 = player;

      ScaffoldMessenger.of(context).showSnackBar(snackBarPlayer1);
      return;
      // ignore: prefer_conditional_assignment
    } else if (player2 == null) {
      player2 = player;

      ScaffoldMessenger.of(context).showSnackBar(snackBarPlayer2);
      return;
    }

    if (checkIfBothPlayersSelected()) {
      showDialog(context: context, builder: (_) => choosePlayerSlot(context))
          .then((value) => {
                if (value == 1)
                  {
                    player1 = player,
                    ScaffoldMessenger.of(context).showSnackBar(snackBarPlayer1)
                  }
                else if (value == 2)
                  {
                    player2 = player,
                    ScaffoldMessenger.of(context).showSnackBar(snackBarPlayer2)
                  }
              });
    }
  }
}
