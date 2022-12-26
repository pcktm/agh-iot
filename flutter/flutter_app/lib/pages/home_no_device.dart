import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/service/api.dart';

import '../models/api_response.dart';
import '../models/user.dart';

class HomeNoDevice extends StatefulWidget {
  const HomeNoDevice({super.key});

  @override
  _HomeNoDeviceState createState() => _HomeNoDeviceState();
}

class _HomeNoDeviceState extends State<HomeNoDevice> {
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

  void _newDevice() async {
    Navigator.pushNamed(context, '/pair');
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
              const SizedBox(height: 60),
              SizedBox(
                  width: 200,
                  height: 150,
                  child: Image.asset('asset/images/hand.png')),
              Container(
                  height: 50,
                  margin: const EdgeInsets.all(60.0),
                  width: 250,
                  child: ElevatedButton(
                    onPressed: _newDevice,
                    child: const Text(
                      'Add device',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ))
            ],
          ),
        ));
  }
}
