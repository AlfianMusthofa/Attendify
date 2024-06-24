import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String locationMsg = 'We are checking location!';

  late bool servicePermission = false;
  late LocationPermission permission;
  Position? _currentPosition;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('Location'),
              GestureDetector(
                onTap: () async {
                  _currentPosition = await getLokasi();
                  print('${_currentPosition}');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Center(
                    child: Text('data'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
