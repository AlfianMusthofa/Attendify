import 'package:debug_atttendify/pages/Splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MainApp(cameras: cameras));
}

class MainApp extends StatelessWidget {
  late List<CameraDescription> cameras;
  MainApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SplashScreen(cameras: cameras),
      ),
    );
  }
}
