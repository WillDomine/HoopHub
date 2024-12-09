class PlayerModelProfile {
  final int season;
  final int playerId;
  final String playerName;
  final String pos;
  final String team;
  final int games;
  String fgPercent;
  String x3Percent;
  String ftPercent;
  final String astPerGame;
  final String rebPerGame;
  final String stlPerGame;
  final String blkPerGame;
  final double ptsPerGame;

  factory PlayerModelProfile.fromJson(Map<String, dynamic> json) {
    return PlayerModelProfile(
      season: json['season'],
      playerId: json['player_id'],
      playerName: json['player'],
      pos: json['pos'] ?? '',
      team: json['tm'] ?? 'TOT',
      games: json['g'] ?? 0,
      fgPercent: json['fg_percent'] ?? '0',
      x3Percent: json['x3p_percent'] ?? '0',
      ftPercent: json['ft_percent'] ?? '0',
      astPerGame: json['ast_per_game'] ?? '0',
      rebPerGame: json['trb_per_game'] ?? '0',
      stlPerGame: json['stl_per_game'] ?? '0',
      blkPerGame: json['blk_per_game'] ?? '0',
      ptsPerGame: json['pts_per_game'].toDouble() ?? 0.0,
    );
  }

  PlayerModelProfile({
    required this.season,
    required this.playerId,
    required this.playerName,
    required this.pos,
    required this.team,
    required this.games,
    required this.fgPercent,
    required this.x3Percent,
    required this.ftPercent,
    required this.astPerGame,
    required this.rebPerGame,
    required this.stlPerGame,
    required this.blkPerGame,
    required this.ptsPerGame,
  });
}
