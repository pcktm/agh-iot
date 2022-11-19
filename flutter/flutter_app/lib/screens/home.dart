// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_app/models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   void _handleLogout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('userId');
//     Navigator.pushNamedAndRemoveUntil(
//         context, '/login', ModalRoute.withName('/login'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User args = ModalRoute.of(context).settings.arguments;
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Home"),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Text("Welcome back " + args.name + "!"),
//               Text("Last login was on " + args.lastLogin),
//               Text("Your Email is  " + args.email),
//               RaisedButton(
//                 onPressed: _handleLogout,
//                 child: Text("Logout"),
//               )
//             ],
//           ),
//         ));
//   }
// }