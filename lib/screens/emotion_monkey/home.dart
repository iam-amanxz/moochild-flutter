import 'package:flutter/material.dart';
import 'package:moochild/screens/test_screen.dart';

class EMHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF1A2980), Color(0xFF26D0CE)])),
          child: Column(
            children: <Widget>[
              // !Hero Area
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Image(
                    image: AssetImage('assets/images/em_logo.png'),
                  ), // color: Colors.grey[200],
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
                            builder: (context) => TestPage(),
                          ));
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/em_btn_play.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/em_btn_challenge.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => MNLeaderboard(),
                          // ));
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/em_btn_leaderboard.png'),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => MNSettingsPage(),
                          // ));
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/buttons/em_btn_settings.png'),
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
