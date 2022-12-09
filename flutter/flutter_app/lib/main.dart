import 'package:flutter/material.dart';
import 'package:flutter_app/landing.dart';
import 'package:flutter_app/pages/laundry.dart';
import 'pages/home_device.dart';
import 'pages/register.dart';
import 'pages/home_landing.dart';
import 'pages/home_no_device.dart';
import 'pages/new_session.dart';
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
        // '/': (context) => NewSession(),
        '/': (context) => Landing(),
        '/login': (context) => const LoginDemo(),
        '/home_landing': (context) => const HomeLanding(),
        '/register': (context) => const Register(),
        '/home_no_device': (context) => const HomeNoDevice(),
        '/home_device': (context) => const HomeDevice(),
        '/new_session': (context) => const NewSession(),
        '/laundry': (context) => const Laundry(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // debugShowCheckedModeBanner: false,
      // home: LoginDemo(),
    );
  }
}
