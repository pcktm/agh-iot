import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/laundry_session.dart';
import 'package:flutter_app/service/api.dart';
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
  late bool waitForDevice;
  late Timer timer;

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

  _fetchSessions() async {
    sessions = await fetchSessions();
    if (sessions.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home_device', ModalRoute.withName('/home_device'));
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, '/laundry', ModalRoute.withName('/laundry'));
    }
  }

  _loadUserInfo() async {
    devices = await fetchDevices();

    if (waitForDevice && devices.isEmpty) {
      timer = Timer.periodic(
          const Duration(seconds: 5),
          (Timer t) async => {
                devices = await fetchDevices(),
                if (devices.isNotEmpty) {timer.cancel()}
              });
    }
    if (devices.isEmpty && !waitForDevice) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home_no_device', ModalRoute.withName('/home_no_device'));
    } else {
      if (devices.isEmpty) {
        timer = Timer.periodic(
            const Duration(seconds: 5),
            (Timer t) async => {
                  devices = await fetchDevices(),
                  if (devices.isNotEmpty) {timer.cancel(), _fetchSessions()}
                });
      } else {
        _fetchSessions();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    waitForDevice = ModalRoute.of(context)!.settings.arguments as bool;
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
