class PlayerModelProfile {
  final int season;
  final int playerId;
  final String pos;
  final String team;
  final int games;
  final String fgPercent;
  final String x3Percent;
  final String ftPercent;

  factory PlayerModelProfile.fromJson(Map<String, dynamic> json) {
    return PlayerModelProfile(
      season: json['season'],
      playerId: json['player_id'],
      pos: json['pos'],
      team: json['tm'],
      games: json['g'],
      fgPercent: json['fg_percent'],
      x3Percent: json['x3p_percent'],
      ftPercent: json['ft_percent'],
    );
  }

  PlayerModelProfile({
    required this.season,
    required this.playerId,
    required this.pos,
    required this.team,
    required this.games,
    required this.fgPercent,
    required this.x3Percent,
    required this.ftPercent,
  });
}
