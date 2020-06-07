import 'package:flutter/material.dart';
import 'package:moochild/components/loading.dart';
import 'package:moochild/models/user.dart';
import 'package:provider/provider.dart';
import 'package:moochild/services/database_service.dart';

class SBSettingsPage extends StatefulWidget {
  @override
  _SBSettingsPageState createState() => _SBSettingsPageState();
}

class _SBSettingsPageState extends State<SBSettingsPage> {
  int _currDifficulty;
  int _currAmtQuestions;
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

    return StreamBuilder<SBUserSettings>(
        stream: DatabaseService(uid: user.uid).getSbUserSettings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SBUserSettings settings = snapshot.data;
            return loading
                ? Loading()
                : Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Difficulty',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Slider(
                            value: (_currDifficulty ?? settings.sbDifficulty)
                                .toDouble(),
                            activeColor: Colors.blueGrey,
                            inactiveColor: Colors.grey[300],
                            min: 1,
                            max: 3,
                            divisions: 2,
                            label: _difficulty,
                            onChanged: (val) => setState(
                                () => _currDifficulty = val.toInt().round())),
                        SizedBox(
                          height: 40.0,
                        ),
                        Text('Number of questions',
                            style: TextStyle(fontSize: 18.0)),
                        SizedBox(
                          height: 20.0,
                        ),
                        Slider(
                            value: (_currAmtQuestions ??
                                    settings.sbNumberOfQuestions)
                                .toDouble(),
                            activeColor: Colors.blueGrey,
                            inactiveColor: Colors.grey[300],
                            min: 5,
                            max: 50,
                            divisions: 44,
                            label: '$_currAmtQuestions',
                            onChanged: (val) => setState(
                                () => _currAmtQuestions = val.toInt().round())),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                            color: Colors.amberAccent,
                            child: Container(
                              width: 150.0,
                              child: Text(
                                'Update',
                                textAlign: TextAlign.center,
                                // style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () async {
                              setState(() => loading = true);
                              await DatabaseService(uid: user.uid)
                                  .updateSBSettings(
                                _currDifficulty ?? settings.sbDifficulty,
                                _currAmtQuestions ??
                                    settings.sbNumberOfQuestions,
                              );
                              setState(() => loading = false);
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  );
          } else {
            return Loading();
          }
        });
  }
}
