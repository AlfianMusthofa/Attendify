import 'dart:io';

import 'package:camera/camera.dart';
import 'package:debug_atttendify/pages/cameraPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceOutPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const AttendanceOutPage({super.key, required this.cameras});

  @override
  State<AttendanceOutPage> createState() => _AttendanceOutPageState();
}

class _AttendanceOutPageState extends State<AttendanceOutPage> {
  File? selectedImage;
  late bool servicePermission = false;
  late LocationPermission permission;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unggah Foto'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                selectedImage != null
                    ? Image.file(selectedImage!)
                    : Text('Ambil gambar!'),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CameraPage(cameras: widget.cameras),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple[900],
                    ),
                    child: Text(
                      'Kamera',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
