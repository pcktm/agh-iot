import 'package:flutter/material.dart';
// import 'package:flutterloginrestapi/models/api_response.dart';
// import 'package:flutterloginrestapi/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/api_error.dart';
import 'models/user.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String _userId = "";

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
        //arguments: (_apiResponse.Data as User)
      );
    }

    // _userId = (prefs.getString('userId') ?? "");
    // Navigator.pushNamedAndRemoveUntil(
    //     context, '/login', ModalRoute.withName('/login'));
    // TODO: sprawdzać czy user zalogowany
    // if (_userId == "") {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, '/login', ModalRoute.withName('/login'));
    // } else {
    //   ApiResponse _apiResponse = await getUserDetails(_userId);
    //   if ((_apiResponse.ApiError as ApiError) == null) {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, '/home', ModalRoute.withName('/home'),
    //         arguments: (_apiResponse.Data as User));
    //   } else {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, '/login', ModalRoute.withName('/login'));
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
