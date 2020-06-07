// MATH NINJA GAME DATA
class MNGameData {
  final String mnUserName;
  final double mnRatio;
  final int mnPoints;
  final int mnGamesPlayed;

  MNGameData(
      {this.mnUserName, this.mnGamesPlayed, this.mnRatio, this.mnPoints});
}

// SPELLING BEE GAME DATA
class SBGameData {
  final String sbUserName;
  final int sbPoints;
  final double sbRatio;
  final int sbGamesPlayed;

  SBGameData(
      {this.sbUserName, this.sbGamesPlayed, this.sbPoints, this.sbRatio});
}
