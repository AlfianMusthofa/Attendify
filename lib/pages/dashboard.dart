import 'package:camera/camera.dart';
import 'package:debug_atttendify/pages/historyPage.dart';
import 'package:debug_atttendify/pages/homePage.dart';
import 'package:debug_atttendify/pages/profilePage.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Dashboard({super.key, required this.cameras});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedPage = 0;

  // final List _listPage = [
  //   HomePage(),
  //   HistoryPage(),
  //   ProfilePage(),
  // ];

  void navigateBottomBar(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _listPage = [
      HomePage(cameras: widget.cameras),
      HistoryPage(),
      ProfilePage(cameras: widget.cameras),
    ];

    return Scaffold(
      body: _listPage[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Presensi'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
