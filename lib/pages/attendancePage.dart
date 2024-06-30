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
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) =>
                //             CameraPage(cameras: widget.cameras),
                //       ),
                //     );
                //   },
                //   child: Container(
                //     padding: EdgeInsets.symmetric(
                //       vertical: 10,
                //       horizontal: 30,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.purple[900],
                //     ),
                //     child: Text(
                //       'Kamera',
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () async {
                    camera();
                    getLokasi().then((position) {
                      var longtitude = position.longitude;
                      var langtitude = position.latitude;
                      print('${position}');
                      postLocation(longtitude, langtitude);
                    });
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
                      'Cameras',
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
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    selectedImage = File(photo!.path);
    setState(() {});

    await sendFace(context);
  }

  Future<void> sendFace(BuildContext context) async {
    final url = 'https://flask-app-5zxttw4pva-et.a.run.app/predict';
    final uri = Uri.parse(url);

    final request = http.MultipartRequest('POST', uri)
      ..files
          .add(await http.MultipartFile.fromPath('image', selectedImage!.path));

    // final streamResponse = await request.send();

    // final response = await http.Response.fromStream(streamResponse);

    // if (response.statusCode == 200) {
    //   showSuccessMessage(context, msg: 'Berhasil Absen!');
    //   print('Success Absence!');
    // } else {
    //   showErrorMessage(context, msg: 'Gagal Absen!');
    //   print('Failed Absence!');
    // }

    try {
      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        showSuccessMessage(context, msg: 'Berhasil Absen!');
        print('Success Absence!');
      } else {
        showErrorMessage(context,
            msg: 'Gagal Absen! Status: ${response.statusCode}');
        print('Failed Absence! Status: ${response.statusCode}');
      }
    } catch (e) {
      showErrorMessage(context, msg: 'Gagal mengirim data: $e');
      print('Error sending data: $e');
    }
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
      showErrorMessage(context, msg: 'Anda diluar jangkauan!');
      print('Status code ${response.statusCode}');
      print('Status ${response.body}');
    }

    Navigator.of(context).pop();
  }
}
