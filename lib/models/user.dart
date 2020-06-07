class User {
  final String displayName;
  final String uid;
  User({this.uid, this.displayName});
}

//! math ninja
class MNUserSettings {
  final String uid;
  final int mnDifficulty;
  final int mnNumberOfQuestions;
  final bool mnIsAddition;
  final bool mnIsSubtraction;
  final bool mnIsMultiplication;
  final bool mnIsDivision;

  MNUserSettings({
    this.uid,
    this.mnDifficulty,
    this.mnNumberOfQuestions,
    this.mnIsAddition,
    this.mnIsSubtraction,
    this.mnIsMultiplication,
    this.mnIsDivision,
  });
}

class MNUserGameData {
  final String uid;
  final String displayName;
  final double mnRatio;
  final int mnPoints;
  final int mnGamesPlayed;

  MNUserGameData(
      {this.uid,
      this.displayName,
      this.mnGamesPlayed,
      this.mnPoints,
      this.mnRatio});
}

//! SPELLING BEE
class SBUserSettings {
  final String uid;
  final int sbDifficulty;
  final int sbNumberOfQuestions;

  SBUserSettings({
    this.uid,
    this.sbDifficulty,
    this.sbNumberOfQuestions,
  });
}

class SBUserGameData {
  final String uid;
  final String displayName;
  final double sbRatio;
  final int sbPoints;
  final int sbGamesPlayed;

  SBUserGameData(
      {this.uid,
      this.displayName,
      this.sbGamesPlayed,
      this.sbPoints,
      this.sbRatio});
}
