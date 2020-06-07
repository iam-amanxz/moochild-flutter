import 'package:moochild/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moochild/screens/login_screen.dart';
import 'package:moochild/screens/home_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Login widget
    if (user == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}
