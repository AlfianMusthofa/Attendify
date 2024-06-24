import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:debug_atttendify/pages/cameraPage.dart';
import 'package:debug_atttendify/utilities/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AttendancePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const AttendancePage({super.key, required this.cameras});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  File? selectedImage;
  late bool servicePermission = false;
  late LocationPermission permission;
  Position? _currentPosition;

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

  Future camera() async {
    // final returnedImage = await ImagePicker();
    // final XFile? imagePicked = await picke

    // if (returnedImage == null) return;
    // setState(() {
    //   selectedImage = File(returnedImage.path);
    // });

    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    selectedImage = File(photo!.path);
    setState(() {});

    getLokasi().then((position) {
      var logtitude = position.longitude;
      var langtitude = position.altitude;
      postLocation(logtitude, langtitude);
    });
  }

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
      showSuccessMessage(context, msg: 'Presensi berhasil!');
    } else {
      showErrorMessage(context, msg: 'Presensi gagal!');
      print('Status code ${response.statusCode}');
      print('Status ${response.body}');
    }

    Navigator.of(context).pop();
  }
}
