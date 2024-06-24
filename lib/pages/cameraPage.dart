import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:debug_atttendify/pages/attendancePage.dart';
import 'package:debug_atttendify/utilities/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  late Future<void> cameraValue;
  bool isFlasesOn = false;
  bool isRearCamera = true;
  late bool servicePermission = false;
  late LocationPermission permission;
  Position? _currentPosition;
  final storage = FlutterSecureStorage();

  Future<Position> getLokasi() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print('Failed');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> postLocation(double longitude, double latitude) async {
    final url = Uri.parse('https://attendifying.vercel.app/location');
    var longtitude = longitude;
    var langtitude = latitude;
    String? token = await storage.read(key: 'token');
    final body = {
      "latitude": langtitude,
      "longitude": longtitude,
    };

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AttendancePage(cameras: widget.cameras),
          ),
        );
      });

      showSuccessMessage(context, msg: 'Presensi berhasil!');
    } else {
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AttendancePage(cameras: widget.cameras),
          ),
        );
      });

      showErrorMessage(context, msg: 'Presensi gagal!');
      print('Status code ${response.statusCode}');
      print('Status ${response.body}');
    }

    Navigator.of(context).pop();
  }

  void startCamera(int camera) {
    controller = CameraController(
      widget.cameras[camera],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    cameraValue = controller.initialize();
  }

  @override
  void initState() {
    startCamera(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getLokasi().then((position) {
            var longtitude = position.longitude;
            var langtitude = position.latitude;
            print('${position}');
            postLocation(longtitude, langtitude);
          });
        },
        backgroundColor: Color.fromRGBO(255, 255, 255, 7),
        shape: CircleBorder(),
        child: Icon(
          Icons.camera,
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 100,
                      child: CameraPreview(controller),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 5, top: 10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFlasesOn = !isFlasesOn;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: isFlasesOn
                              ? Icon(
                                  Icons.flash_on,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : Icon(
                                  Icons.flash_off,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRearCamera = !isRearCamera;
                        });
                        isRearCamera ? startCamera(0) : startCamera(1);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: isRearCamera
                              ? Icon(
                                  Icons.camera_rear,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : Icon(
                                  Icons.camera_front,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
