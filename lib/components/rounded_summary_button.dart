import 'package:flutter/material.dart';

class RoundedSummaryButton extends StatelessWidget {
  RoundedSummaryButton({this.title, @required this.onPressed, this.color});

  final String title;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 60.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 27.0),
          ),
        ),
      ),
    );
  }
}
