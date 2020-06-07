import 'package:flutter/material.dart';
import 'package:moochild/screens/emotion_monkey/home.dart';
import 'package:moochild/screens/login_screen.dart';
import 'package:moochild/screens/math_ninja/home.dart';
import 'package:moochild/screens/spelling_bee/home.dart';
import 'package:moochild/services/auth_service.dart';
import 'package:moochild/components/game_mode_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsetsDirectional.only(top: 30.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFFB721FF), Color(0xFF21D4FD)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // !Logo Area
              Expanded(
                flex: 3,
                child: Container(
                  child: Image(
                    image: AssetImage('assets/images/home_logo.png'),
                  ),
                ),
              ),
              // !Game Modes Cards
              Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GameModeCard(
                            title: 'Emotion Monkey',
                            description:
                                'You think you can express your emotions flawlessly?',
                            icon: Icons.insert_emoticon,
                            ontap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EMHomePage(),
                              ));
                            },
                          ),
                          GameModeCard(
                            title: 'Math Ninja',
                            description:
                                'The Robber is here to test you math skills',
                            icon: Icons.iso,
                            ontap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MNHomePage(),
                              ));
                            },
                          ),
                          GameModeCard(
                            title: 'Spelling Bee',
                            description:
                                'Challenge our AI with your spelling skills',
                            icon: Icons.keyboard_voice,
                            ontap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SBHomePage(),
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
              // !Signout Area
              Container(
                  // color: Colors.grey[100],
                  child: IconButton(
                      icon: Icon(
                        Icons.no_encryption,
                        color: Colors.white60,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(
                                    "Moochild",
                                  ),
                                  content: Text("Sign out?"),
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
                                      onPressed: () async {
                                        setState(() => loading = true);
                                        await _auth.signOut().whenComplete(() {
                                          setState(() => loading = false);
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                            return LoginPage();
                                          }), ModalRoute.withName('/'));
                                        });
                                      },
                                      child: Text(
                                        'Yes',
                                      ),
                                    )
                                  ],
                                ));
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
