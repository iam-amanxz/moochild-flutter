// import 'package:flutter/material.dart';
// import 'package:moochild/components/game_mode_card.dart';
// import 'package:moochild/screens/math_ninja/home.dart';
// import 'package:moochild/screens/spelling_bee/home.dart';

// class TestScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage('assets/images/home_bg.jpg'),
//                 fit: BoxFit.cover),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               // !Signout Area
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                     color: Colors.grey[100],
//                     child: IconButton(
//                         icon: Icon(Icons.verified_user),
//                         onPressed: () async {
//                           setState(() => loading = true);
//                           await _auth.signOut().whenComplete(() {
//                             setState(() => loading = false);
//                             Navigator.of(context).pushAndRemoveUntil(
//                                 MaterialPageRoute(builder: (context) {
//                               return LoginPage();
//                             }), ModalRoute.withName('/'));
//                           });
//                         })),
//               ),
//               // !Logo Area
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   color: Colors.grey[300],
//                 ),
//               ),
//               // !Game Modes Cards
//               Expanded(
//                   flex: 6,
//                   child: Padding(
//                     padding: EdgeInsets.all(20.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(80.0),
//                           color: Colors.white24),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           GameModeCard(
//                             title: 'Emotion Monkey',
//                             // description:
//                             //     'You think you can express your emotions flawlessly?',
//                             icon: Icons.insert_emoticon,
//                             ontap: () {},
//                           ),
//                           GameModeCard(
//                             title: 'Math Ninja',
//                             // description:
//                             //     'You think you can express your emotions flawlessly?',
//                             icon: Icons.iso,
//                             ontap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => MNHomePage(),
//                               ));
//                             },
//                           ),
//                           GameModeCard(
//                             title: 'Spelling Bee',
//                             // description:
//                             //     'You think you can express your emotions flawlessly?',
//                             icon: Icons.keyboard_voice,
//                             ontap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => SBHomePage(),
//                               ));
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
