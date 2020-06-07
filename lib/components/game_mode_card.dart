import 'package:flutter/material.dart';

class GameModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Function ontap;

  GameModeCard({this.title, this.description, this.icon, this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFFFFFFF).withOpacity(0),
                    Color(0xFFFFFFF).withOpacity(1)
                  ])),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 45.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    icon,
                    size: 55.0,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black.withOpacity(0.75)),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            // fontSize: 15.0,
                            color: Colors.black.withOpacity(0.75)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
