import 'package:flutter/material.dart';
// import 'package:flutterloginrestapi/models/api_response.dart';
// import 'package:flutterloginrestapi/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/api_error.dart';
import 'models/user.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("token") ?? "");
    if (token == "") {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home_landing', ModalRoute.withName('/home_landing'),
          arguments: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
