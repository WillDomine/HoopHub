//
// Model for player data to be used in query
//
class Player {
  final String name;
  final String firstSeason;
  final String lastSeason;
  final String? playerId;

  Player(this.name, this.firstSeason, this.lastSeason, this.playerId);
}