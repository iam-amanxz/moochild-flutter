import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moochild/models/user.dart';
import 'package:moochild/services/database_service.dart';
import 'package:moochild/components/loading.dart';

class MNSettingsPage extends StatefulWidget {
  @override
  _MNSettingsState createState() => _MNSettingsState();
}

class _MNSettingsState extends State<MNSettingsPage> {
  int _currDifficulty;
  int _currNumOfQuestions;
  bool _currIsSubtraction;
  bool _currIsMultiplication;
  bool _currIsDivision;
  String _difficulty;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    switch (_currDifficulty) {
      case 1:
        _difficulty = 'Low';
        break;
      case 2:
        _difficulty = 'Medium';
        break;
      case 3:
        _difficulty = 'High';
        break;
    }

    return StreamBuilder<MNUserSettings>(
        stream: DatabaseService(uid: user.uid).getMnUserSettings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MNUserSettings settings = snapshot.data;
            return loading
                ? Loading()
                : Scaffold(
                    body: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Difficulty',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Slider(
                                value:
                                    (_currDifficulty ?? settings.mnDifficulty)
                                        .toDouble(),
                                activeColor: Colors.blueGrey,
                                inactiveColor: Colors.grey[300],
                                min: 1,
                                max: 3,
                                divisions: 2,
                                label: _difficulty,
                                onChanged: (val) => setState(() =>
                                    _currDifficulty = val.toInt().round())),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Number of questions',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Slider(
                                value: (_currNumOfQuestions ??
                                        settings.mnNumberOfQuestions)
                                    .toDouble(),
                                activeColor: Colors.blueGrey,
                                inactiveColor: Colors.grey[300],
                                min: 5,
                                max: 50,
                                divisions: 44,
                                label: '$_currNumOfQuestions',
                                onChanged: (val) => setState(() =>
                                    _currNumOfQuestions = val.toInt().round())),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text('Operation Types',
                                style: TextStyle(fontSize: 18.0)),
                            SizedBox(
                              height: 20.0,
                            ),
                            ListTile(
                              title: Text('Addition'),
                              trailing: Checkbox(
                                value: true,
                                onChanged: (val) => {
                                  //nothing
                                },
                                activeColor: Colors.blueGrey,
                              ),
                            ),
                            ListTile(
                              title: Text('Subtraction'),
                              trailing: Checkbox(
                                value: _currIsSubtraction ??
                                    settings.mnIsSubtraction,
                                onChanged: (val) =>
                                    setState(() => _currIsSubtraction = val),
                                activeColor: Colors.blueGrey,
                              ),
                            ),
                            ListTile(
                              title: Text('Multiplication'),
                              trailing: Checkbox(
                                value: _currIsMultiplication ??
                                    settings.mnIsMultiplication,
                                onChanged: (val) =>
                                    setState(() => _currIsMultiplication = val),
                                activeColor: Colors.blueGrey,
                              ),
                            ),
                            ListTile(
                              title: Text('Division'),
                              trailing: Checkbox(
                                value: _currIsDivision ?? settings.mnIsDivision,
                                onChanged: (val) =>
                                    setState(() => _currIsDivision = val),
                                activeColor: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            RaisedButton(
                                color: Colors.greenAccent,
                                child: Container(
                                  width: 150.0,
                                  child: Text(
                                    'Update',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() => loading = true);
                                  await DatabaseService(uid: user.uid)
                                      .updateMnSettings(
                                    _currDifficulty ?? settings.mnDifficulty,
                                    _currNumOfQuestions ??
                                        settings.mnNumberOfQuestions,
                                    true,
                                    _currIsSubtraction ??
                                        settings.mnIsSubtraction,
                                    _currIsMultiplication ??
                                        settings.mnIsMultiplication,
                                    _currIsDivision ?? settings.mnIsDivision,
                                  );
                                  setState(() => loading = false);
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ),
                    ),
                  );
          } else {
            return Loading();
          }
        });
  }
}
