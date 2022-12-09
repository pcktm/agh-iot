import 'package:flutter/material.dart';
import 'package:flutter_app/pages/laundry.dart';
import 'package:flutter_app/pages/new_session.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/service/api.dart';

import '../models/api_response.dart';
import '../models/user.dart';

class HomeDevice extends StatefulWidget {
  const HomeDevice({super.key});

  @override
  _HomeDeviceState createState() => _HomeDeviceState();
}

class _HomeDeviceState extends State<HomeDevice> {
  late ApiResponse _apiResponse;
  late Future<User> futureUser;

  Future<User> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    return getUser(token);
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  void startSession() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/new_session', ModalRoute.withName('/new_session'));
    // Navigator.push(
    //   context,
    //   // MaterialPageRoute(builder: (context) => const NewSession()),
    //   MaterialPageRoute(builder: (context) => Laundry()),
    // );
  }

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _handleLogout,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.logout_rounded),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<User>(
                  future: futureUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text("Hi, ${snapshot.data!.name}!",
                          style: const TextStyle(
                              color: Colors.blue, fontSize: 30));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  }),
              const SizedBox(height: 30),
              const Text("You have no pranie history...",
                  style: TextStyle(color: Colors.blue, fontSize: 20)),
              Container(
                  height: 50,
                  margin: const EdgeInsets.all(60.0),
                  width: 250,
                  // padding: const EdgeInsets.only(top: 40.0),
                  child: ElevatedButton(
                    onPressed: startSession,
                    child: const Text(
                      'Start first pranie',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ))
            ],
          ),
        ));
  }
}
