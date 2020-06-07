import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moochild/components/loading.dart';
import 'package:moochild/components/mn_answer_button.dart';
import 'package:moochild/models/user.dart';
import 'package:moochild/screens/home_screen.dart';
import 'package:moochild/screens/math_ninja/summary.dart';
import 'package:moochild/services/database_service.dart';
import 'package:moochild/services/math_ninja_service.dart';
import 'package:provider/provider.dart';

class MNInitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final _service = MathNinjaService();
    return StreamBuilder<MNUserSettings>(
        stream: DatabaseService(uid: user.uid).getMnUserSettings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MNUserSettings settings = snapshot.data;
            int _difficulty = settings.mnDifficulty;
            int _numOfQuestions = settings.mnNumberOfQuestions;
            List<bool> _operations = [
              settings.mnIsAddition,
              settings.mnIsSubtraction,
              settings.mnIsMultiplication,
              settings.mnIsDivision
            ];
            dynamic questionsAndAnswers = _service.generateQuestionAndAnswer(
                _operations, _difficulty, _numOfQuestions);

            return MNGamePage(
                gameData: questionsAndAnswers, numofquestions: _numOfQuestions);
          } else {
            return Loading();
          }
        });
  }
}

class MNGamePage extends StatefulWidget {
  final dynamic gameData;
  final int numofquestions;
  MNGamePage({Key key, @required this.gameData, this.numofquestions})
      : super(key: key);

  @override
  _MNGamePageState createState() => _MNGamePageState(gameData, numofquestions);
}

class _MNGamePageState extends State<MNGamePage> {
  final dynamic gameData;
  final int numofquestions;
  _MNGamePageState(this.gameData, this.numofquestions);

  Color rightColor = Colors.greenAccent;
  Color wrongColor = Colors.redAccent;
  Color buttonColor = Colors.indigoAccent;
  int score = 0;
  int i = 0;
  int timer = 5;
  String showTimer = '5';
  int choosenAnswer;
  dynamic finalAnswers;
  bool canceltimer = false;
  int currentQuestion = 1;

  @override
  void initState() {
    starttimer();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  dynamic generateAnswers() {
    Random r = Random();
    List<int> answersArray;
    int answer1 = gameData[i][3];
    int answer2 = r.nextInt(answer1 + 5) + (answer1 - 5);
    int answer3 = r.nextInt(answer1 + 5) + (answer1 - 5);

    while (answer2 == answer1) {
      answer2 = r.nextInt(answer1 + 5) + (answer1 - 5);
      continue;
    }
    while (answer3 == answer1) {
      answer3 = r.nextInt(answer1 + 5) + (answer1 - 5);
      continue;
    }
    while (answer2 == answer3) {
      answer2 = r.nextInt(answer1 + 5) + (answer1 - 5);
      continue;
    }
    answersArray = [answer1, answer2, answer3];

    return answersArray..shuffle();
  }

  //* Function to start the timer
  void starttimer() async {
    finalAnswers = generateAnswers();

    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          finalAnswers = generateAnswers();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showTimer = timer.toString();
      });
    });
  }

  //* Function to change question
  void nextquestion() {
    canceltimer = false;
    timer = 5;
    setState(() {
      if (i < numofquestions - 1) {
        currentQuestion++;
        i++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MNSummaryPage(
            score: score,
            questions: numofquestions,
          ),
        ));
      }
      buttonColor = Colors.indigoAccent;
    });
    starttimer();
  }

  void checkanswer() {
    if (gameData[i][3] == choosenAnswer) {
      score = score + 1000;
      buttonColor = rightColor;
    } else {
      score = score - 100;
      buttonColor = wrongColor;
    }
    setState(() {
      canceltimer = true;
    });
    Timer(Duration(seconds: 1), nextquestion);
  }

  @override
  Widget build(BuildContext context) {
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ));
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
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
                  child: Column(
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: TextStyle(
                                fontFamily: 'Fredoka', fontSize: 40.0),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Score: ',
                                  style: TextStyle(color: Colors.blueGrey)),
                              TextSpan(
                                  text: score.toString(),
                                  style: TextStyle(color: Colors.greenAccent)),
                            ]),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        '$currentQuestion / $numofquestions',
                        style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 30.0,
                            color: Colors.blueGrey),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '00:' + showTimer,
                            style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 20.0,
                                color: Colors.pinkAccent),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: double.parse(showTimer) / 10,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.amber),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'What is...?',
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 35.0),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      // !QUESTION AREA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            gameData[i][0].toString(),
                            style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 65.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]),
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: Colors.amber,
                              height: 70.0,
                              width: 70.0,
                              child: Text(
                                gameData[i][1].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Fredoka',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50.0,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Text(
                            gameData[i][2].toString(),
                            style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 65.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 65.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // !ANSWER AREA
                    children: <Widget>[
                      AnswerButton(
                        title: finalAnswers[0].toString(),
                        color: buttonColor,
                        onPressed: () {
                          choosenAnswer = finalAnswers[0];
                          checkanswer();
                        },
                      ),
                      AnswerButton(
                        title: finalAnswers[1].toString(),
                        color: buttonColor,
                        onPressed: () {
                          choosenAnswer = finalAnswers[1];
                          checkanswer();
                        },
                      ),
                      AnswerButton(
                        title: finalAnswers[2].toString(),
                        color: buttonColor,
                        onPressed: () {
                          choosenAnswer = finalAnswers[2];
                          checkanswer();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
