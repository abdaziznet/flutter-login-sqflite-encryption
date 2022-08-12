import 'package:flutter/material.dart';
import 'package:flutter_login_signup_sqflite_app/screens/login_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login With Signup Sqflite',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginForm(),
    );
  }
}
