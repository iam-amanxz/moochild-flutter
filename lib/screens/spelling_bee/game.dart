import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:moochild/models/user.dart';
import 'package:moochild/screens/home_screen.dart';
import 'package:moochild/screens/spelling_bee/summary.dart';
import 'package:moochild/services/spelling_bee_service.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:moochild/services/database_service.dart';
import 'package:moochild/components/loading.dart';

class SBInitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final _service = SpellingBeeService();

    return StreamBuilder<SBUserSettings>(
        stream: DatabaseService(uid: user.uid).getSbUserSettings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SBUserSettings settings = snapshot.data;
            int _difficulty = settings.sbDifficulty;
            int _numOfQuestions = settings.sbNumberOfQuestions;
            dynamic words =
                _service.generateWords(_difficulty, _numOfQuestions);
            return SBGamePage(words: words, amtQuestions: _numOfQuestions);
          } else {
            return Loading();
          }
        });
  }
}

class SBGamePage extends StatefulWidget {
  final List<String> words;
  final int amtQuestions;
  SBGamePage({Key key, @required this.words, @required this.amtQuestions})
      : super(key: key);

  @override
  _SBGamePageState createState() => _SBGamePageState(words, amtQuestions);
}

// Defining TTS enum for state
enum TtsState { playing, stopped }

class _SBGamePageState extends State<SBGamePage> {
  final List<String> words;
  final int amtQuestions;
  _SBGamePageState(this.words, this.amtQuestions);

  // TTS Setups
  FlutterTts flutterTts;
  final double volume = 1.0;
  final double pitch = 1.0;
  final double rate = 0.5;
  TtsState ttsState = TtsState.playing;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  // Game variables
  final Color rightColor = Colors.blueAccent;
  final Color wrongColor = Colors.redAccent;
  Color buttonColor = Color(0xff00D99E);
  Color scoreColor = Color(0xff00D99E);
  int score = 0;
  int i = 0;
  int timer = 15;
  String showTimer = '15';
  String choosenAnswer;
  bool canceltimer = false;
  int currentQuestion = 1;
  final double height = 40.0;
  final double width = 35.0;
  final double margin = 2.5;
  final Color color = Colors.blueAccent;
  final Color fontColor = Colors.white;
  final double fontSize = 20.0;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    starttimer();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();
    flutterTts.setVolume(volume);
    flutterTts.setSpeechRate(rate);
    flutterTts.setPitch(pitch);
    flutterTts.setLanguage('en-GB');
    ttsState = TtsState.playing;

    _speak();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });
    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  void onpressedButton(String k) {
    _textController.text += k;
    print(_textController.text);
  }

  void clearLast() {
    if (_textController.text.length > 0) {
      _textController.text =
          _textController.text.substring(0, _textController.text.length - 1);
    }
  }

  void clearAll() {
    _textController.clear();
  }

  void onSkip() {
    scoreColor = wrongColor;
    score = score - 100;
    Timer(Duration(seconds: 1), nextquestion);
  }

  Future _speak() async {
    print(words[i]);
    await flutterTts.speak(words[i]);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
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

  void nextquestion() {
    buttonColor = Color(0xff00D99E);
    scoreColor = Color(0xff00D99E);
    canceltimer = false;
    timer = 15;
    setState(() {
      if (i < amtQuestions - 1) {
        currentQuestion++;
        i++;
        _speak();
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SBSummaryPage(
            score: score,
            questions: amtQuestions,
          ),
        ));
      }
    });
    starttimer();
  }

  void checkanswer() {
    if (choosenAnswer.toLowerCase() == words[i].toLowerCase()) {
      score = score + 500;
      buttonColor = rightColor;
    } else {
      buttonColor = wrongColor;
    }
    setState(() {
      canceltimer = true;
    });
    Timer(Duration(seconds: 1), nextquestion);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    canceltimer = true;
  }

  @override
  Widget build(BuildContext context) {
    _textController.text;
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
                              builder: (BuildContext context) => HomePage()),
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
              //! Score and Timer
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        '$currentQuestion / $amtQuestions',
                        style:
                            TextStyle(fontSize: 25.0, color: Colors.blueGrey),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '00:' + showTimer,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.deepOrangeAccent),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: double.parse(showTimer) / 10.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.deepOrangeAccent),
                              ),
                            )
                          ],
                        ),
                      ),
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
                                  style: TextStyle(color: scoreColor)),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              //! Input Area
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: TextFormField(
                          controller: _textController,
                          onChanged: (val) {
                            choosenAnswer = val;
                          },
                          textCapitalization: TextCapitalization.characters,
                          readOnly: true,
                          cursorWidth: 3.0,
                          cursorColor: Colors.greenAccent,
                          maxLength: words[i].length,
                          showCursor: true,
                          textAlign: TextAlign.center,
                          autocorrect: false,
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.indigoAccent,
                            letterSpacing: 5.0,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 3.0),
                            ),
                          ),
                        )),
                  )),
              //! Play Area
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Ink(
                      decoration: const ShapeDecoration(
                        color: Color(0xff00D99E),
                        shadows: <BoxShadow>[
                          BoxShadow(
                              color: Color(0xff00D99E),
                              blurRadius: 8,
                              offset: Offset(0, 5),
                              spreadRadius: -1)
                        ],
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.play_arrow),
                        color: Colors.white,
                        iconSize: 65.0,
                        onPressed: () {
                          _speak();
                        },
                        tooltip: 'Click to play again',
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Play Sound',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),
                    )
                  ],
                ),
              ),
              //! Keyboard Area
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(margin),
                          child: RaisedButton(
                            color: Colors.orangeAccent,
                            onPressed: () {
                              _textController.clear();
                              onSkip();
                            },
                            child: Text(
                              'SKIP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          width: 180.0,
                          margin: EdgeInsets.all(margin),
                          child: RaisedButton(
                            color: buttonColor,
                            onPressed: () {
                              choosenAnswer = _textController.text;
                              checkanswer();
                              _textController.clear();
                            },
                            child: Text(
                              'SUBMIT',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('Q');
                            },
                            child: Text(
                              'Q',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('W');
                            },
                            child: Text(
                              'W',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('E');
                            },
                            child: Text(
                              'E',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('R');
                            },
                            child: Text(
                              'R',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('T');
                            },
                            child: Text(
                              'T',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('Y');
                            },
                            child: Text(
                              'Y',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('U');
                            },
                            child: Text(
                              'U',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('I');
                            },
                            child: Text(
                              'I',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('O');
                            },
                            child: Text(
                              'O',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('P');
                            },
                            child: Text(
                              'P',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('A');
                            },
                            child: Text(
                              'A',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('S');
                            },
                            child: Text(
                              'S',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('D');
                            },
                            child: Text(
                              'D',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('F');
                            },
                            child: Text(
                              'F',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('G');
                            },
                            child: Text(
                              'G',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('H');
                            },
                            child: Text(
                              'H',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('J');
                            },
                            child: Text(
                              'J',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('K');
                            },
                            child: Text(
                              'K',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('L');
                            },
                            child: Text(
                              'L',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('Z');
                            },
                            child: Text(
                              'Z',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('X');
                            },
                            child: Text(
                              'X',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('C');
                            },
                            child: Text(
                              'C',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('V');
                            },
                            child: Text(
                              'V',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('B');
                            },
                            child: Text(
                              'B',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('N');
                            },
                            child: Text(
                              'N',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.all(margin),
                          height: height,
                          width: width,
                          child: RaisedButton(
                            color: color,
                            onPressed: () {
                              onpressedButton('M');
                            },
                            child: Text(
                              'M',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: fontColor, fontSize: fontSize),
                            ),
                          )),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(margin),
                            height: height,
                            child: RaisedButton(
                              color: Colors.redAccent,
                              onPressed: () {
                                clearAll();
                              },
                              child: Text(
                                'Clear All',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: fontColor, fontSize: fontSize),
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.all(margin),
                            height: height,
                            child: RaisedButton(
                              color: Colors.orangeAccent,
                              onPressed: () {
                                clearLast();
                              },
                              child: Text(
                                'Clear Last',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: fontColor, fontSize: fontSize),
                              ),
                            )),
                      ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
