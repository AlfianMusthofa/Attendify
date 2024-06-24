import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:debug_atttendify/components/inputField.dart';
import 'package:debug_atttendify/components/myButton.dart';
import 'package:debug_atttendify/pages/dashboard.dart';
import 'package:debug_atttendify/pages/signupPage.dart';
import 'package:debug_atttendify/utilities/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const LoginPage({super.key, required this.cameras});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  // Logo
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Image.asset(
                      'lib/assets/logo2.png',
                      width: 170,
                    ),
                  ),

                  // InputField
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 70),
                    child: Column(
                      children: [
                        const Text(
                          'Selamat Datang Kembali!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 35),
                        InputField(
                          label: 'Email',
                          obscureText: false,
                          controller: emailController,
                        ),
                        const SizedBox(height: 18),
                        InputField(
                          label: 'Kata Sandi',
                          obscureText: true,
                          controller: passwordController,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: const Text(
                                'Lupa kata sandi?',
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  // TO HOME
                  MyButton(
                    width: 250,
                    label: 'Masuk',
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    borderRadius: BorderRadius.circular(10),
                    fontSize: 15,
                    onTap: login,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 45),

                  // KE HALAMAN REGISTRASI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun ?',
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SignUpPage(cameras: widget.cameras),
                            ),
                          );
                        },
                        child: Text(
                          ' ayo buat!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purple[900],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    final body = {
      "email": email,
      "password": password,
    };

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final url =
        Uri.parse('https://attendify-three.vercel.app/api/v1/user/login');

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('Response data : $data');

      final String? token = data['data']['token'];

      if (token != null) {
        showSuccessMessage(context, msg: 'Selamat Datang!');

        // FLUTTER SECURE STORAGE
        await storage.write(key: 'token', value: token);
        print('Login Berhasil! $token');

        Future.delayed(Duration(seconds: 1)).then(
          (value) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Dashboard(
                    cameras: widget.cameras,
                  ),
                ),
                (route) => false);
          },
        );
      } else {
        print('Token tidak ditemukan di response');
      }
    } else {
      showErrorMessage(context, msg: 'Email atau Password salah!');
      print('login gagal : ${response.body}');
    }
    Navigator.of(context).pop();
  }
}
