import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking',
      theme: ThemeData(),
      home: AuthScreen(),
    );
  }
}
