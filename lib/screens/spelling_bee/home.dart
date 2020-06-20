import 'package:flutter/material.dart';
import 'package:moochild/screens/spelling_bee/game.dart';
import 'package:moochild/screens/spelling_bee/leaderboard.dart';
import 'package:moochild/screens/spelling_bee/settings.dart';

class SBHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SBSettingsPage(),
            );
          });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.redAccent, Colors.amberAccent])),
          child: Column(
            children: <Widget>[
              // !Hero Area
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Image(
                    image: AssetImage('assets/images/sb_logo.png'),
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
                            builder: (context) => SBInitPage(),
                          ));
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/sb_btn_play.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      // InkWell(
                      //   // onTap: () {
                      //   //   Navigator.of(context).push(MaterialPageRoute(
                      //   //     builder: (context) => SBInitPage(),
                      //   //   ));
                      //   // },
                      //   child: Image(
                      //     image: AssetImage(
                      //         'assets/images/buttons/sb_btn_challenge.png'),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 15.0,
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SBLeaderboard(),
                          ));
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/sb_btn_leaderboard.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      InkWell(
                        onTap: () => _showSettingsPanel(),
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/sb_btn_settings.png'),
                        ),
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
