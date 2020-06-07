import 'package:flutter/material.dart';
import 'package:moochild/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moochild/components/loading.dart';

class MNLeaderboard extends StatefulWidget {
  @override
  _MNLeaderboardState createState() => _MNLeaderboardState();
}

class _MNLeaderboardState extends State<MNLeaderboard> {
  bool flag = false;
  dynamic datas = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await DatabaseService().getMnLeaderboardData().then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        List<DocumentSnapshot> gamedata = docs.documents;

        for (int i = 0; i < gamedata.length; i++) {
          datas.add(gamedata[i].data);
        }
        setState(() {
          flag = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return flag == false
        ? Loading()
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Text(
                        'Math Ninja Leaders',
                        style: TextStyle(fontSize: 35.0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: ListView.builder(
                        itemCount: datas.length,
                        itemBuilder: (context, index) {
                          return UserTile(
                              userdata: datas[index], dataIndex: index + 1);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class UserTile extends StatelessWidget {
  final dynamic userdata;
  final int dataIndex;
  UserTile({this.userdata, this.dataIndex});

  @override
  Widget build(BuildContext context) {
    print('userdata $userdata');
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              child: Text(dataIndex.toString()),
            ),
            title: Text(
              userdata['mn_username'],
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 20.0),
            ),
            subtitle: Text(
                'Points: ${userdata['mn_points']}    Ratio: ${userdata['mn_ratio']}',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 15.0)),
          ),
        ),
      ),
    );
  }
}
