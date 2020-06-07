import 'package:flutter/material.dart';
import 'package:moochild/models/user.dart';
import 'package:moochild/screens/splash_screen.dart';
import 'package:moochild/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        title: 'Moochild Kids App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'Fredoka',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: {},
      ),
    );
  }
}
