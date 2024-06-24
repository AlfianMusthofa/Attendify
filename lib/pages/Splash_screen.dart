import 'package:camera/camera.dart';
import 'package:debug_atttendify/utilities/checkAuth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SplashScreen({super.key, required this.cameras});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3)).then(
      (value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CheckAuth(cameras: widget.cameras),
          ),
          (route) => false,
        );
      },
    );

    return Scaffold(
      backgroundColor: Color(0xff213E60),
      body: Center(
        child: Image.asset(
          'lib/assets/logo.png',
          width: 300,
        ),
      ),
    );
  }
}
