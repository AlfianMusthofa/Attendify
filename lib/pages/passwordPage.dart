import 'dart:convert';

import 'package:debug_atttendify/utilities/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  TextEditingController sandiLamaController = TextEditingController();
  TextEditingController sandiBaruController = TextEditingController();
  TextEditingController konfirmSandiBaruController = TextEditingController();
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff213E60),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xff213E60),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 45,
                  right: 45,
                  bottom: 40,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'Masukkan Kata Sandi Baru',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Row(
                        children: [
                          Text(
                            'Kata sandi baru harus berbeda dengan kata\nsandi yang digunakan sebelumnya.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Text(
                            'Kata sandi lama',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Material(
                        elevation: 5,
                        child: TextField(
                          controller: sandiLamaController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(15),
                            hintText: 'Kata Sandi',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Text(
                            'Kata sandi baru',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Material(
                        elevation: 5,
                        child: TextField(
                          controller: sandiBaruController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(15),
                            hintText: 'Kata Sandi Baru',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Text(
                            'Konfirmasi kata sandi baru',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Material(
                        elevation: 5,
                        child: TextField(
                          controller: konfirmSandiBaruController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(15),
                            hintText: 'Konfirmasi Kata Sandi Baru',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(7),
                        child: GestureDetector(
                          onTap: updatePassword,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xff213E60),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Center(
                              child: Text(
                                'Verifikasi dan Proses',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 180),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getCurrentToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> updatePassword() async {
    String? currentToken = await getCurrentToken();
    final url = Uri.parse('https://attendify-three.vercel.app/api/v1/user');

    final sandiLama = sandiLamaController.text;
    final sandiBaru = sandiBaruController.text;
    final konfirmSandi = konfirmSandiBaruController.text;

    if (sandiBaru != konfirmSandi) {
      showErrorMessage(context, msg: 'Konfirmasi sandi tidak cocok!');
      return;
    }

    final body = {
      "password": sandiLama,
      "newPassword": sandiBaru,
    };

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $currentToken",
      },
    );

    if (response.statusCode == 200) {
      showSuccessMessage(context, msg: 'Update berhasil!');
    } else {
      showErrorMessage(context, msg: 'Update Gagal!');
      print('Error : ${response.body}');
      print('Error : ${response.statusCode}');
    }

    Navigator.of(context).pop();
  }
}
