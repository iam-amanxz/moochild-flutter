import 'package:flutter/material.dart';
import 'package:moochild/screens/math_ninja/game.dart';
import 'package:moochild/screens/math_ninja/leaderboard.dart';
import 'package:moochild/screens/math_ninja/settings.dart';

class MNHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.greenAccent, Color(0xFFF4D03F)])),
          child: Column(
            children: <Widget>[
              // !Hero Area
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Image(
                    image: AssetImage('assets/images/mn_logo.png'),
                  ),
                ),
              ),
              // !Buttons Area
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MNInitPage(),
                          ));
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/mn_btn_play.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     // Navigator.of(context).push(MaterialPageRoute(
                      //     //   builder: (context) => MNInitPage(),
                      //     // ));
                      //   },
                      //   child: Image(
                      //     image: AssetImage(
                      //         'assets/images/buttons/mn_btn_challenge.png'),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 15.0,
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MNLeaderboard(),
                          ));
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/mn_btn_leaderboard.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MNSettingsPage(),
                          ));
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/mn_btn_settings.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
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
