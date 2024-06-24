// import 'package:attendify/components/myButton.dart';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:debug_atttendify/components/myButton.dart';
import 'package:debug_atttendify/components/personalInformation.dart';
import 'package:debug_atttendify/pages/attendanceOutPage.dart';
import 'package:debug_atttendify/pages/attendancePage.dart';
import 'package:debug_atttendify/pages/perizinanPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage({super.key, required this.cameras});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  late Future<Map<String, dynamic>> futureUserData;

  @override
  void initState() {
    super.initState();
    futureUserData = fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Purple Decoration
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Color(0xff213E60),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: Text(
                'a',
                style: TextStyle(color: Color(0x213E60)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  FutureBuilder(
                    future: futureUserData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error : ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        var userData = snapshot.data!;
                        // print(userData);
                        return PersonalInformation(
                          name: userData['data']['fullName'] ?? 'Unknown',
                          kelas: userData['data']['gradeClass'] ?? 'Unknown',
                          imagePath: 'lib/assets/person.jpg',
                        );
                      } else {
                        return Text('No data');
                      }
                    },
                  ),

                  // BUTTON WIDGET COLLECTION
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        // PRESENSI MASUK
                        DashboardButton2(
                          label: 'Presensi Masuk',
                          jam: '07.00 WIB',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AttendancePage(cameras: widget.cameras),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 23),

                        // PRESENSI PULANG
                        DashboardButton2(
                          label: 'Presensi Keluar',
                          jam: 'Belum Presensi',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AttendanceOutPage(cameras: widget.cameras),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 23),

                        // ABSENSI
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PermissionPage(),
                              ),
                            );
                          },
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.purple,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tidak bisa hadir ?'),
                                  Icon(Icons.keyboard_arrow_right),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final url = Uri.parse('https://attendify-three.vercel.app/api/v1/user');
    String? token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('No token found!');
    }

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
