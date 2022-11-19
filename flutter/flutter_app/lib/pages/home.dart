import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text("Welcome back " + args.name + "!"),
              // Text("Last login was on " + args.lastLogin),
              // Text("Your Email is  " + args.email),
              const Text("Start your adventure with PRANIE",
                  style: TextStyle(color: Colors.blue, fontSize: 30)),
              Container(
                  height: 50,
                  margin: const EdgeInsets.all(60.0),
                  width: 250,
                  // padding: const EdgeInsets.only(top: 40.0),
                  child: ElevatedButton(
                    onPressed: _handleLogout,
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ))
            ],
          ),
        ));
  }
}
