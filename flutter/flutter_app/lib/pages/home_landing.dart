import 'package:flutter/material.dart';
import 'package:flutter_app/models/laundry_session.dart';
import 'package:flutter_app/service/api.dart';
// import 'package:flutterloginrestapi/models/api_response.dart';
// import 'package:flutterloginrestapi/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/device.dart';

class HomeLanding extends StatefulWidget {
  const HomeLanding({super.key});

  @override
  _HomeLandingState createState() => _HomeLandingState();
}

class _HomeLandingState extends State<HomeLanding> {
  late List<Device> devices;
  late List<LaundrySession> sessions;

  Future<List<Device>> fetchDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    return getDevices(token);
  }

  Future<List<LaundrySession>> fetchSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    return getLaundrySession(token);
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    devices = await fetchDevices();
    if (devices.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home_no_device', ModalRoute.withName('/home_no_device'));
    } else {
      sessions = await fetchSessions();
      if (sessions.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/home_device', ModalRoute.withName('/home_device'));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/laundry', ModalRoute.withName('/home_device'));
      }
    }

    // _userId = (prefs.getString('userId') ?? "");
    // Navigator.pushNamedAndRemoveUntil(
    //     context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
