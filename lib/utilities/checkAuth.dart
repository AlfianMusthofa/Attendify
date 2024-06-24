import 'package:camera/camera.dart';
import 'package:debug_atttendify/pages/dashboard.dart';
import 'package:debug_atttendify/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CheckAuth extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CheckAuth({super.key, required this.cameras});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  final storage = FlutterSecureStorage();
  bool isLogin = false;

  Future<void> cekToken() async {
    String? token = await storage.read(key: 'token');

    if (token != null) {
      setState(() {
        isLogin = true;
      });
    } else {
      setState(() {
        isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLogin
          ? Dashboard(cameras: widget.cameras)
          : LoginPage(cameras: widget.cameras),
    );
  }
}
