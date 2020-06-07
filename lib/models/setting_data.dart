// MATH NINJA SETTINGS DATA
class MNSettings {
  final int mnDifficulty;
  final int mnNumberOfQuestions;
  final bool mnIsAddition;
  final bool mnIsSubtraction;
  final bool mnIsMultiplication;
  final bool mnIsDivision;

  MNSettings({
    this.mnDifficulty,
    this.mnNumberOfQuestions,
    this.mnIsAddition,
    this.mnIsSubtraction,
    this.mnIsMultiplication,
    this.mnIsDivision,
  });
}

// SPELLING BEE SETTINGS DATA
class SBSettings {
  final int sbDifficulty;
  final int sbNumberOfQuestions;

  SBSettings({this.sbDifficulty, this.sbNumberOfQuestions});
}
