import 'package:flutter/material.dart';
import 'package:flutter_app/models/api_error.dart';
import 'package:flutter_app/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';

// Create a Form widget.
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

// Create a corresponding State class, which holds data related to the form.
class _RegisterState extends State<Register> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  bool _autovalidate = false;
  String _username = "", _password = "", _email = "";
  late ApiResponse _apiResponse;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSubmitted() async {
    // final FormState? form = _formKey.currentState;
    if (!_formKey.currentState!.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      _formKey.currentState!.save();
      _apiResponse = await createUser(_username, _email, _password);
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
    // Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
    Navigator.pushNamedAndRemoveUntil(
      context, '/home', ModalRoute.withName('/home'),
      //arguments: (_apiResponse.Data as User)
    );
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
        ),
        body: Center(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Enter your username',
                  labelText: 'Name',
                ),
                onSaved: (value) {
                  _username = value.toString();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail),
                  hintText: 'Enter email address',
                  labelText: 'Email',
                ),
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
                decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  hintText: 'Enter your password',
                  labelText: 'Password',
                ),
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
              Container(
                  height: 50,
                  margin: const EdgeInsets.all(60.0),
                  width: 250,
                  // padding: const EdgeInsets.only(top: 40.0),
                  child: ElevatedButton(
                    onPressed: _handleSubmitted,
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  )),
            ],
          ),
        )));
  }
}
