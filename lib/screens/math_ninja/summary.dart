import 'package:flutter/material.dart';
import 'package:moochild/screens/home_screen.dart';
import 'package:moochild/components/rounded_summary_button.dart';
import 'package:moochild/screens/spelling_bee/game.dart';
import 'package:moochild/models/user.dart';
import 'package:provider/provider.dart';
import 'package:moochild/services/database_service.dart';
import 'package:moochild/components/loading.dart';

class MNSummaryPage extends StatefulWidget {
  final int score;
  final int questions;
  MNSummaryPage({Key key, @required this.score, @required this.questions})
      : super(key: key);
  @override
  _MNSummaryPageState createState() => _MNSummaryPageState(score, questions);
}

class _MNSummaryPageState extends State<MNSummaryPage> {
  final int score;
  final int questions;
  _MNSummaryPageState(this.score, this.questions);
  List<String> images = [
    "assets/images/sb_summary_bad.png",
    "assets/images/sb_summary_good.png",
    "assets/images/sb_summary_bee.png",
    "assets/images/sb_summary_ninja.png"
  ];

  String message;
  String image;

  void initState() {
    if (score / questions <= 150) {
      image = images[0];
      message = "You should try hard..!";
    } else if (score / questions > 150 && score / questions <= 400) {
      image = images[1];
      message = "You Are Getting There, kid. Keep up!";
    } else if (score / questions > 400 && score / questions <= 450) {
      image = images[2];
      message = "Oh Hey There, Math Genius!";
    } else {
      image = images[3];
      message = "Kid, You Are a Math Ninja!";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<MNUserGameData>(
      stream: DatabaseService(uid: user.uid).getMnUserGameData,
      builder: (context, snapshot) {
        print(user.uid);
        print(user.displayName);
        if (snapshot.hasData) {
          MNUserGameData gamedata = snapshot.data;
          int _curgamesplayed = gamedata.mnGamesPlayed;
          int _curpoints = gamedata.mnPoints;
          double _curratio = gamedata.mnRatio;

          int _newgamesplayed = _curgamesplayed + 1;
          int _newpoints = _curpoints + score;
          double _gameratio = ((score ~/ questions) ~/ 50).toDouble();
          double _newratio =
              ((_gameratio + _curratio) ~/ _newgamesplayed).toDouble();
          return WillPopScope(
            onWillPop: () {
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          "Moochild",
                        ),
                        content: Text("Quit the game?"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'No',
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomePage()),
                                ModalRoute.withName('/'),
                              );
                            },
                            child: Text(
                              'Yes',
                            ),
                          )
                        ],
                      ));
            },
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // !YOU SCORED
                          // Text(_platformVersion),
                          Text(
                            'You Scored',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 40.0, color: Colors.blueGrey),
                          ),
                          // !SCORE
                          Text(
                            score.toString(),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 50.0, color: Colors.brown),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // !IMAGE
                            Image(
                              image: AssetImage(image),
                              height: 200.00,
                              width: 200.00,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            // !MESSAGE
                            Text(message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.black87))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // !PLAY AGAIN
                          RoundedSummaryButton(
                            title: 'Play Again',
                            color: Colors.greenAccent,
                            onPressed: () async {
                              await DatabaseService(uid: user.uid)
                                  .updateMnGameData(user.displayName,
                                      _newgamesplayed, _newpoints, _newratio);
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => SBInitPage(),
                              ));
                            },
                          ),
                          // !QUIT
                          RoundedSummaryButton(
                            title: 'Quit',
                            color: Colors.redAccent,
                            onPressed: () async {
                              await DatabaseService(uid: user.uid)
                                  .updateMnGameData(user.displayName,
                                      _newgamesplayed, _newpoints, _newratio);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomePage()),
                                ModalRoute.withName('/'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
