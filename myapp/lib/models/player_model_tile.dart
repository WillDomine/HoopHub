class PlayerModelTile {
  final int playerId;
  final String playerName;
  final int firstSeason;
  final int lastSeason;
  final int timesClicked;

  factory PlayerModelTile.fromJson(Map<String, dynamic> json) {
    return PlayerModelTile(
      playerId: json['player_id'],
      playerName: json['player'],
      firstSeason: json['first_seas'],
      lastSeason: json['last_seas'],
      timesClicked: json['times_clicked'],
    );
  }

  PlayerModelTile({
    required this.playerId,
    required this.playerName,
    required this.firstSeason,
    required this.lastSeason,
    required this.timesClicked,
  });
}
