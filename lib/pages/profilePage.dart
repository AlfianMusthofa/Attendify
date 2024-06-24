// import 'package:attendify/components/personalInformation.dart';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:debug_atttendify/components/profile.dart';
import 'package:debug_atttendify/components/profileButton.dart';
import 'package:debug_atttendify/pages/absenceHistory.dart';
import 'package:debug_atttendify/pages/loginPage.dart';
import 'package:debug_atttendify/pages/passwordPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ProfilePage({super.key, required this.cameras});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      backgroundColor: const Color.fromARGB(106, 158, 158, 158),
      body: Stack(
        children: [
          Container(
            height: 370,
            decoration: BoxDecoration(
              color: Color(0xff213E60),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Column(
                  children: [
                    // Personal information
                    FutureBuilder(
                      future: futureUserData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error : ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          var userData = snapshot.data!;
                          print(userData);
                          return Profile(
                            fullName: userData['data']['fullName'],
                            kelas: userData['data']['gradeClass'],
                            imagePath: 'lib/assets/person.jpg',
                          );
                        } else {
                          return const Text('nodata');
                        }
                      },
                    ),

                    // Utilities
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 40),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 246, 241, 241),
                        ),
                        child: Column(
                          children: [
                            ProfileButton(
                              icon: Icons.lock,
                              label: 'Absence History',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AbsenceHistory(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            ProfileButton(
                              icon: Icons.lock,
                              label: 'Reset Password',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PasswordPage()),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            ProfileButton(
                              icon: Icons.logout,
                              label: 'Logout',
                              onTap: logout,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
    Future.delayed(Duration(seconds: 1)).then(
      (value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(cameras: widget.cameras),
          ),
        );
      },
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
