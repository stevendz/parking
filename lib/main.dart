import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking/screens/splash_screen.dart';
import 'package:parking/screens/welcome_back_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
  await Firebase.initializeApp();
  runApp(
    // MyApp(),
    DevicePreview(
      style: DevicePreviewStyle(
          background: BoxDecoration(color: Colors.white),
          hasFrameShadow: false,
          toolBar: DevicePreviewToolBarStyle(
            backgroundColor: Colors.grey.shade700,
            buttonBackgroundColor: Colors.grey,
            buttonHoverBackgroundColor: Colors.grey,
            foregroundColor: Colors.black,
            position: DevicePreviewToolBarPosition.bottom,
          )),
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.of(context).locale,
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Parking',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Color(0xff795EB7),
      ),
      home: user != null ? WelcomeBackScreen() : SplashScreen(),
    );
  }
}
