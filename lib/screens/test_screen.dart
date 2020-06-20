import 'package:flutter/material.dart';
import 'package:moochild/components/game_mode_card.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(25.0),
                    bottomStart: Radius.circular(25.0)),
                color: Color(0xFFFA003F),
              ),
              child: Padding(
                padding: EdgeInsets.all(35.0),
                child: Image(
                  image: AssetImage(
                    'assets/images/home_logo.png',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Color(0xFFFEEFE5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HomeCard(),
                  HomeCard(),
                  HomeCard(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xFFFE4A49),
            ),
          )
        ],
      ),
    ));
  }
}
