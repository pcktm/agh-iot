import 'package:flutter/material.dart';
import 'package:flutter_app/landing.dart';
import 'package:flutter_app/pages/register.dart';

import 'pages/home.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pranie',
      routes: {
        '/': (context) => Landing(),
        '/login': (context) => LoginDemo(),
        '/home': (context) => HomePage(),
        '/register': (context) => Register(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // debugShowCheckedModeBanner: false,
      // home: LoginDemo(),
    );
  }
}
