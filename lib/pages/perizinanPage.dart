// import 'package:attendify/components/RadioButton.dart';
import 'dart:convert';

import 'package:debug_atttendify/components/myButton.dart';
import 'package:debug_atttendify/utilities/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum keterangan { Izin, Sakit }

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _absenceController = TextEditingController();
  final storage = FlutterSecureStorage();
  keterangan? _keterangan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff213E60),
      appBar: AppBar(
        backgroundColor: Color(0xff213E60),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text(
                'Perizinan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              Container(
                height: 750,
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      // Detail pernyataan tidak hadir
                      const Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detail',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Pernyataan tidak hadir',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      // RADIO BUTTON UNTUK ALASAN
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Radio<keterangan>(
                              value: keterangan.Izin,
                              groupValue: _keterangan,
                              onChanged: (value) {
                                setState(() {
                                  _keterangan = value;
                                });
                              },
                            ),
                            const Text(
                              'Izin',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Radio<keterangan>(
                              value: keterangan.Sakit,
                              groupValue: _keterangan,
                              onChanged: (value) {
                                setState(() {
                                  _keterangan = value;
                                });
                              },
                            ),
                            const Text(
                              'Sakit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tanggal
                      Container(
                        child: Column(
                          children: <Widget>[
                            const Row(
                              children: [
                                Text(
                                  'Tanggal',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),

                            const SizedBox(height: 15),

                            // Date picker
                            Material(
                              elevation: 5,
                              child: TextField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.calendar_today),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple),
                                  ),
                                ),
                                readOnly: true,
                                onTap: () => _selectDate(),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Reason
                      Container(
                        margin: const EdgeInsets.only(top: 25, bottom: 25),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'Alasan',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),

                            const SizedBox(height: 15),

                            // TextBox
                            Material(
                              elevation: 5,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Alasan',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(15),
                                ),
                                minLines: 5,
                                maxLines: 5,
                                controller: _absenceController,
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: MyButton(
                                width: 90,
                                label: 'Kirim',
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                borderRadius: BorderRadius.circular(10),
                                fontSize: 15,
                                onTap: postAbsence,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      )
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

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  // DAPATKAN TOKEN SAAT LOGIN
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // MENCETAK TOKEN YANG DIDAPAT SAAT LOGIN
  Future<void> printCurrentToken() async {
    String? token = await getToken();
    print('Current token : $token');
  }

  // MEMBACA TOKEN HASIL REFRESH
  Future<String?> readRefreshedToken() async {
    getRefreshToken();
    return await storage.read(key: 'refresh_token');
  }

  Future<void> getRefreshToken() async {
    String? token = await getToken();

    final url =
        Uri.parse('https://attendify-three.vercel.app/api/v1/user/token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // AMBIL TOKEN DARI RESPONSE
      Map<String, dynamic> data = json.decode(response.body);
      String? token = data['data']['token'];

      // SIMPAN TOKEN DI SUCURE STORATE
      await storage.write(key: 'refresh_token', value: token);
    } else {
      print('Failed to get refreshed token!');
    }
  }

  Future<void> postAbsence() async {
    final date = _dateController.text;
    final detail = _absenceController.text;

    if (_keterangan == null) {
      showErrorMessage(context, msg: 'Pilih salah satu!');
      return;
    }

    final body = {
      "reason": _keterangan == keterangan.Izin ? 'Izin' : 'Sakit',
      "detail": detail,
      "date": date,
    };

    String? refreshedToken = await readRefreshedToken();
    print('token anda : $refreshedToken');

    final url = Uri.parse('https://attendify-three.vercel.app/api/v1/absence');

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $refreshedToken",
      },
    );

    if (response.statusCode == 201) {
      showSuccessMessage(context, msg: 'Permohonan Dikirim!');
      print('Response body : ${response.body}');
    } else {
      print('Status code : ${response.statusCode}');
      print('Body : ${response.body}');
      showErrorMessage(context, msg: 'Gagal Mengirim!');
    }
  }
}
