import 'dart:convert';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:debug_atttendify/components/inputField.dart';
import 'package:debug_atttendify/components/myButton.dart';
import 'package:debug_atttendify/pages/loginPage.dart';
import 'package:debug_atttendify/utilities/snackbar_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum gender { lakilaki, perempuan }

class SignUpPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SignUpPage({super.key, required this.cameras});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController namaLengkapConroller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController kelasController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  gender? _gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Image.asset(
                    'lib/assets/logo2.png',
                    width: 200,
                  ),
                  Text('Ayo buat akunmu!'),
                  SizedBox(height: 40),
                  InputField(
                    label: 'Nama lengkap',
                    obscureText: false,
                    controller: namaLengkapConroller,
                  ),
                  SizedBox(height: 15),

                  // UNTUK GENDER
                  Material(
                    elevation: 5,
                    shadowColor: Colors.black38,
                    child: DropdownButton2<gender>(
                      hint: const Text(
                        'Gender',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: gender.lakilaki,
                          child: Text(
                            'Laki - laki',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: gender.perempuan,
                          child: Text(
                            'Perempuan',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                      value: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      isExpanded: true,
                      buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  InputField(
                    label: 'Kelas',
                    obscureText: false,
                    controller: kelasController,
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    label: 'Tahun',
                    obscureText: false,
                    controller: yearController,
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    label: 'Email',
                    obscureText: false,
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),
                  InputField(
                    label: 'Password',
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    width: 150,
                    label: 'Registrasi',
                    padding: EdgeInsets.symmetric(vertical: 13),
                    borderRadius: BorderRadius.circular(5),
                    fontSize: 14,
                    onTap: registrasi,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String generateStudentIdNumber() {
    final random = Random();
    final length = 10;
    String studentId = '';
    for (int i = 0; i < length; i++) {
      studentId += random.nextInt(10).toString();
    }
    return studentId;
  }

  Future<void> registrasi() async {
    // GET DATA FROM USER REGISTRASI
    final namaLengkap = namaLengkapConroller.text;
    final kelas = kelasController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final year = yearController.text;
    final url =
        Uri.parse('https://attendify-three.vercel.app/api/v1/user/register');

    if (_gender == null) {
      showErrorMessage(context, msg: 'Pilih gender anda!');
      return;
    }

    final body = {
      "studentIdNumber": generateStudentIdNumber(),
      "fullName": namaLengkap,
      "gender": _gender == gender.lakilaki ? 'Laki-laki' : 'Perempuan',
      "gradeClass": kelas,
      "year": year,
      "email": email,
      "password": password,
    };

    print(body);

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final response = await http.post(
      url,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      showSuccessMessage(context, msg: 'Berhasil Mendaftar');
      Future.delayed(
        Duration(seconds: 1),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                cameras: widget.cameras,
              ),
            ),
          );
        },
      );
    } else {
      showErrorMessage(context, msg: 'Gagal Mendaftar');
      print(body);
      print('Response ${response.body}');
    }

    Navigator.of(context).pop();
  }
}
