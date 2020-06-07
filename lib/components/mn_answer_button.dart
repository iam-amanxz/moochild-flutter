import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  AnswerButton({
    this.k,
    this.title,
    @required this.onPressed,
    this.color,
    this.rightColor,
    this.wrongColor,
  });
  final String k;
  final String title;
  final Color color;
  final Color rightColor;
  final Color wrongColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 75.0,
          height: 75.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 45.0),
          ),
        ),
      ),
    );
  }
}
