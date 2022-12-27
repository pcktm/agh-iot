import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/api_error.dart';
import 'package:flutter_app/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_iot/wifi_iot.dart';

import '../models/api_response.dart';
import '../models/user.dart';

// Create a Form widget.
class Pair extends StatefulWidget {
  const Pair({super.key});

  @override
  _PairState createState() => _PairState();
}

// Create a corresponding State class, which holds data related to the form.
class _PairState extends State<Pair> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  String _wifi = "", _password = "";
  late ApiResponse _apiResponse;
  late Timer timer;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String _ssid = 'iot-device';
  bool connected = false;
  String? currentSsid;
  // bool connected = true;
  late User user;

  @override
  void initState() {
    super.initState();
    connectToAP();
  }

  void fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    user = await getUser(token);
  }

  Future refresh() async {
    connectToAP();
  }

  void checkConnection() async {
    currentSsid = await WiFiForIoTPlugin.getSSID();
    if (currentSsid == _ssid) {
      setState(() {
        connected = true;
      });
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void connectToAP() async {
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    user = await getUser(token);
    timer = Timer.periodic(
        const Duration(seconds: 5),
        (Timer t) async => {
              await WiFiForIoTPlugin.connect(_ssid),
              checkConnection(),
              // await WiFiForIoTPlugin.isConnected().then((val) {
              //   setState(() {
              //     connected = val;
              //   });
              // }),
              if (connected) {timer.cancel()}
            });
  }

  void _handleSubmitted() async {
    // final FormState? form = _formKey.currentState;

    if (!_formKey.currentState!.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      _formKey.currentState!.save();
      checkConnection();
      if (!connected) {
        showInSnackBar("Lost connection to device. Reconnecting...");
        refresh();
        return;
      }
      _apiResponse = await pairDevice(user.id, _wifi, _password);
      if ((_apiResponse.apiError) == null) {
        await WiFiForIoTPlugin.disconnect();
        showInSnackBar("Pairing...");
        sleep(const Duration(seconds: 5));
        _saveAndRedirectToHome();
      } else {
        showInSnackBar((_apiResponse.apiError as ApiError).error.toString());
      }
    }
  }

  void _saveAndRedirectToHome() async {
    Navigator.pushNamedAndRemoveUntil(
        context, '/home_landing', ModalRoute.withName('/home_landing'),
        arguments: true);
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    if (!connected) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pairing"),
        ),
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),
                    Text("Connected to $_ssid!",
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 20)),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.wifi),
                        hintText: 'Enter your wifi name',
                        labelText: 'Wifi Name',
                      ),
                      onSaved: (value) {
                        _wifi = value.toString();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wifi name is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        hintText: 'Enter wifi password',
                        labelText: 'Wifi Password',
                      ),
                      onSaved: (value) {
                        _password = value.toString();
                      },
                    ),
                    Container(
                        height: 50,
                        margin: const EdgeInsets.all(60.0),
                        width: 250,
                        // padding: const EdgeInsets.only(top: 40.0),
                        child: ElevatedButton(
                          onPressed: _handleSubmitted,
                          child: const Text(
                            'Pair',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        )),
                  ],
                ),
              )
            ])));
  }
}
