import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AbsenceHistory extends StatefulWidget {
  const AbsenceHistory({super.key});

  @override
  State<AbsenceHistory> createState() => _AbsenceHistoryState();
}

class _AbsenceHistoryState extends State<AbsenceHistory> {
  final storage = FlutterSecureStorage();
  List<dynamic> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    absenceHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: data.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index]['status']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reason: ${data[index]['reason']}'),
                        Text('Detail: ${data[index]['detail']}'),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> absenceHistory() async {
    final url = Uri.parse('https://attendify-three.vercel.app/api/v1/absence');

    String? token = await storage.read(key: 'token');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        data = jsonResponse['data'];
      });
    } else {
      print('Failed to fetch data');
    }
  }
}
