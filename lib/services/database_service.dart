import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moochild/models/setting_data.dart';
import 'package:moochild/models/game_data.dart';
import 'package:moochild/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // !MATH NINJA
  final CollectionReference mnSettingsCollection =
      Firestore.instance.collection('mathNinjaSettings');

  final CollectionReference mnGameDataCollection =
      Firestore.instance.collection('mathNinjaGameData');

  Future<void> updateMnSettings(
      int difficulty,
      int numberOfQuestions,
      bool isAddition,
      bool isSubtraction,
      bool isMultiplication,
      bool isDivision) async {
    return await mnSettingsCollection.document(uid).setData({
      'mn_difficulty': difficulty,
      'mn_number_of_questions': numberOfQuestions,
      'mn_is_addition': isAddition,
      'mn_is_subtraction': isSubtraction,
      'mn_is_multiplication': isMultiplication,
      'mn_is_division': isDivision,
    });
  }

  Future<void> updateMnGameData(
      String username, int gamesPlayed, int points, double ratio) async {
    return await mnGameDataCollection.document(uid).setData({
      'mn_username': username,
      'mn_games_played': gamesPlayed,
      'mn_points': points,
      'mn_ratio': ratio,
    });
  }

  MNUserSettings _mnUserSettingsFromSnapshot(DocumentSnapshot snapshot) {
    return MNUserSettings(
      uid: uid,
      mnDifficulty: snapshot.data['mn_difficulty'],
      mnNumberOfQuestions: snapshot.data['mn_number_of_questions'],
      mnIsAddition: snapshot.data['mn_is_addition'],
      mnIsSubtraction: snapshot.data['mn_is_subtraction'],
      mnIsMultiplication: snapshot.data['mn_is_multiplication'],
      mnIsDivision: snapshot.data['mn_is_division'],
    );
  }

  MNUserGameData _mnUserGameDataFromSnapshot(DocumentSnapshot snapshot) {
    return MNUserGameData(
        uid: uid,
        mnGamesPlayed: snapshot.data['mn_games_played'],
        mnPoints: snapshot.data['mn_points'],
        mnRatio: snapshot.data['mn_ratio']);
  }

  Stream<MNUserSettings> get getMnUserSettings {
    return mnSettingsCollection
        .document(uid)
        .snapshots()
        .map(_mnUserSettingsFromSnapshot);
  }

  Stream<MNUserGameData> get getMnUserGameData {
    return mnGameDataCollection
        .document(uid)
        .snapshots()
        .map(_mnUserGameDataFromSnapshot);
  }

  List<MNSettings> _mnSettingsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return MNSettings(
        mnDifficulty: doc.data['mn_difficulty'] ?? 1,
        mnNumberOfQuestions: doc.data['mn_number_of_questions'] ?? 5,
        mnIsAddition: doc.data['mn_is_addition'] ?? true,
        mnIsSubtraction: doc.data['mn_is_subtraction'] ?? false,
        mnIsMultiplication: doc.data['mn_is_multiplication'] ?? false,
        mnIsDivision: doc.data['mn_is_division'] ?? false,
      );
    }).toList();
  }

  List<MNGameData> _mnGameDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return MNGameData(
        mnGamesPlayed: doc.data['mn_games_played'] ?? 0,
        mnPoints: doc.data['mn_points'] ?? 0,
        mnRatio: doc.data['mn_ratio'] ?? 0,
      );
    }).toList();
  }

  Stream<List<MNSettings>> get getMnSettings {
    return mnSettingsCollection.snapshots().map(_mnSettingsFromSnapshot);
  }

  Stream<List<MNGameData>> get getMnGameData {
    return mnGameDataCollection.snapshots().map(_mnGameDataFromSnapshot);
  }

  getMnLeaderboardData() {
    return Firestore.instance
        .collection('mathNinjaGameData')
        .orderBy('mn_points', descending: true)
        .limit(10)
        .getDocuments();
  }

  // !SPELLING BEE
  final CollectionReference sbSettingsCollection =
      Firestore.instance.collection('spellingBeeSettings');

  final CollectionReference sbGameDataCollection =
      Firestore.instance.collection('spellingBeeGameData');

  Future<void> updateSBSettings(int difficulty, int numberOfQuestions) async {
    return await sbSettingsCollection.document(uid).setData({
      'sb_difficulty': difficulty,
      'sb_number_of_questions': numberOfQuestions,
    });
  }

  Future<void> updateSbGameData(
      String username, int gamesPlayed, int points, double ratio) async {
    return await sbGameDataCollection.document(uid).setData({
      'sb_username': username,
      'sb_games_played': gamesPlayed,
      'sb_points': points,
      'sb_ratio': ratio,
    });
  }

  SBUserSettings _sbUserSettingsFromSnapshot(DocumentSnapshot snapshot) {
    return SBUserSettings(
      uid: uid,
      sbDifficulty: snapshot.data['sb_difficulty'],
      sbNumberOfQuestions: snapshot.data['sb_number_of_questions'],
    );
  }

  SBUserGameData _sbUserGameDataFromSnapshot(DocumentSnapshot snapshot) {
    return SBUserGameData(
        uid: uid,
        sbGamesPlayed: snapshot.data['sb_games_played'],
        sbPoints: snapshot.data['sb_points'],
        sbRatio: snapshot.data['sb_ratio']);
  }

  Stream<SBUserSettings> get getSbUserSettings {
    return sbSettingsCollection
        .document(uid)
        .snapshots()
        .map(_sbUserSettingsFromSnapshot);
  }

  Stream<SBUserGameData> get getSbUserGameData {
    return sbGameDataCollection
        .document(uid)
        .snapshots()
        .map(_sbUserGameDataFromSnapshot);
  }

  List<SBSettings> _sbSettingsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return SBSettings(
        sbDifficulty: doc.data['sb_difficulty'] ?? 1,
        sbNumberOfQuestions: doc.data['sb_number_of_questions'] ?? 10,
      );
    }).toList();
  }

  List<SBGameData> _sbGameDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return SBGameData(
        sbGamesPlayed: doc.data['sb_games_played'] ?? 0,
        sbPoints: doc.data['sb_points'] ?? 0,
        sbRatio: doc.data['sb_ratio'] ?? 0,
      );
    }).toList();
  }

  Stream<List<SBSettings>> get getSbSettings {
    return sbSettingsCollection.snapshots().map(_sbSettingsFromSnapshot);
  }

  Stream<List<SBGameData>> get getSbGameData {
    return sbGameDataCollection.snapshots().map(_sbGameDataFromSnapshot);
  }

  getSbLeaderboardData() {
    return Firestore.instance
        .collection('spellingBeeGameData')
        .orderBy('sb_points', descending: true)
        .limit(10)
        .getDocuments();
  }
}
