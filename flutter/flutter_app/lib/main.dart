import 'package:flutter/material.dart';

import 'HomePage.dart';
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
        '/': (context) => LoginDemo(),
        '/login': (context) => LoginDemo(),
        // '/home': (context) => MyHomePage(title: 'Login Demo'),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // debugShowCheckedModeBanner: false,
      // home: LoginDemo(),
    );
  }
}

