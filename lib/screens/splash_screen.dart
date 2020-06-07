import 'dart:async';
// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:moochild/wrapper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 4), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Wrapper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Color(0xFFB721FF).withOpacity(1),
            Color(0xFF21D4FD).withOpacity(1)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'home_logo',
              child: Image(
                image: AssetImage('assets/images/home_logo.png'),
                height: 175.0,
              ),
            ),
            // SizedBox(
            //   height: 10.0,
            // ),
            // TyperAnimatedTextKit(
            //     text: [
            //       'Made by Husnul Aman',
            //     ],
            //     speed: Duration(milliseconds: 150),
            //     isRepeatingAnimation: false,
            //     textAlign: TextAlign.center,
            //     textStyle: TextStyle(
            //         fontSize: 25.0,
            //         fontFamily: "Pacifico",
            //         color: Colors.white70),
            //     alignment: AlignmentDirectional.topStart),
          ],
        ),
      ),
    );
  }
}
