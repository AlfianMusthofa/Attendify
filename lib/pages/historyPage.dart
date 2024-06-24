import 'package:debug_atttendify/components/historyComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final storage = FlutterSecureStorage();
  bool _isPresensiDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: const Text('Riwayat'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  'Senin',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Tab(
                child: Text(
                  'Selasa',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Tab(
                child: Text(
                  'Rabu',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Tab(
                child: Text(
                  'Kamis',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Tab(
                child: Text(
                  'Jumat',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(72, 158, 158, 158),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Column(
                // SENIN
                children: [
                  HistoryComponent(
                    label: 'Presensi Masuk',
                    jamMasuk: '07.00 WIB',
                    icon: _isPresensiDone
                        ? Icons.check_circle
                        : Icons.cancel_rounded,
                  ),
                  HistoryComponent(
                    label: 'Presensi Keluar',
                    jamMasuk: '15.30 WIB',
                    icon: Icons.check_circle,
                  ),
                  HistoryComponent(
                    label: 'Status',
                    jamMasuk: 'Hadir',
                    icon: Icons.check_circle,
                  ),
                ],
              ),
            ),

            // SELASA
            Center(
              child: Text("It's rainy here"),
            ),

            // RABU
            Center(
              child: Text("It's sunny here"),
            ),

            // KAMIS
            Center(
              child: Text("It's sunny here"),
            ),

            // JUMAT
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getAttendance() async {
    String? token = await storage.read(key: 'token');
    final now = DateTime.now();
    final lastPresensiTime = await storage.read(key: 'lastPresensiTime');
    final url = Uri.parse(
        'https://attendify-three.vercel.app/api/v1/attendance?type=daily');

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (lastPresensiTime != null) {
      final lastTime = DateTime.parse(lastPresensiTime);
      final difference = now.difference(lastTime).inHours;

      if (difference < 24) {
        setState(() {
          _isPresensiDone = true;
        });
        return;
      }
    }

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _isPresensiDone = true;
        print('Response ${response.body}');
      });
    } else {
      setState(() {
        _isPresensiDone = false;
      });
    }

    Navigator.of(context).pop();
  }
}
