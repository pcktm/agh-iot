import 'package:flutter/material.dart';
import 'package:flutter_app/models/api_error.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:flutter_app/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginDemo extends StatefulWidget {
  const LoginDemo({super.key});

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email = "", _password = "";
  late ApiResponse _apiResponse;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSubmitted() async {
    // final FormState? form = _formKey.currentState;
    if (!_formKey.currentState!.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      _formKey.currentState!.save();
      _apiResponse = await authenticateUser(_email, _password);
      if ((_apiResponse.apiError) == null) {
        _saveAndRedirectToHome();
      } else {
        showInSnackBar((_apiResponse.apiError as ApiError).error.toString());
      }
    }
  }

  void _saveAndRedirectToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", _apiResponse.data.toString());
    Navigator.pushNamedAndRemoveUntil(
        context, '/home_landing', ModalRoute.withName('/home_landing'),
        arguments: false);
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image.asset('asset/images/washing-machine.png')),
              ),
            ),
            Form(
                // autovalidate: true,
                key: _formKey,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              key: const Key("_email"),
                              decoration:
                                  const InputDecoration(labelText: "Email"),
                              keyboardType: TextInputType.text,
                              onSaved: (value) {
                                _email = value.toString();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Password"),
                              obscureText: true,
                              onSaved: (value) {
                                _password = value.toString();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ],
                    ))),
            Container(
              margin: const EdgeInsets.all(60.0),
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: _handleSubmitted,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                'New user? Register',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
