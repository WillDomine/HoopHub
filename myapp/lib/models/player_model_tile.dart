class PlayerTile {
  final int playerId;
  final String playerName;
  final int firstSeason;
  final int lastSeason;
  final int timesClicked;

  factory PlayerTile.fromJson(Map<String, dynamic> json) {
    return PlayerTile(
      playerId: json['player_id'],
      playerName: json['player'],
      firstSeason: json['first_seas'],
      lastSeason: json['last_seas'],
      timesClicked: json['times_clicked'],
    );
  }

  PlayerTile({
    required this.playerId,
    required this.playerName,
    required this.firstSeason,
    required this.lastSeason,
    required this.timesClicked,
  });
}
