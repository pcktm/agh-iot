// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   bool _autovalidate = false;
//   String? _email, _password;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   void showInSnackBar(String value) {
//     _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(value)));
//   }

// void _handleSubmitted() async {
//     final FormState form = _formKey.currentState;
//     if (!form.validate()) {
//       showInSnackBar('Please fix the errors in red before submitting.');
//     } else {
//       form.save();
//       _apiResponse = await authenticateUser(_username, _password);
//       if ((_apiResponse.ApiError as ApiError) == null) {
//         _saveAndRedirectToHome();
//       } else {
//         showInSnackBar((_apiResponse.ApiError as ApiError).error);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: Text('Login'),
//         ),
//         body: SafeArea(
//           top: false,
//           bottom: false,
//           child: Form(
//             autovalidate: true,
//             key: _formKey,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         TextFormField(
//                           key: Key("_username"),
//                           decoration: InputDecoration(labelText: "Username"),
//                           keyboardType: TextInputType.text,
//                           onSaved: (String value) {
//                             _username = value;
//                           },
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Username is required';
//                             }
//                             return null;
//                           },
//                         ),
//                         TextFormField(
//                           decoration: InputDecoration(labelText: "Password"),
//                           obscureText: true,
//                           onSaved: (String value) {
//                             _password = value;
//                           },
//                           validator: (value) {
//                             if (value.isEmpty) {
//                               return 'Password is required';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 10.0),
//                         ButtonBar(
//                           children: <Widget>[
//                             RaisedButton.icon(
//                                 onPressed: _handleSubmitted,
//                                 icon: Icon(Icons.arrow_forward),
//                                 label: Text('Sign in')),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ]),
//             ),
//           ),
//         ));
//   }}