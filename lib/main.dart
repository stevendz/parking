import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parking/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  await Firebase.initializeApp();
  runApp(
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: DevicePreview.of(context).locale,
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Parking',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Color(0xff795EB7),
      ),
      home: SplashScreen(),
    );
  }
}
