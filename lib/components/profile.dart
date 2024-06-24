import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  // final PersonalInformationModel personalInformationModel;
  final fullName, kelas, imagePath;

  const Profile({
    Key? key,
    // required this.personalInformationModel,
    required this.fullName,
    required this.kelas,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Column(
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 17),
            ClipOval(
              child: Image.asset(
                imagePath,
                width: 120,
              ),
            ),
            const SizedBox(height: 17),
            Text(
              fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              kelas + ' - ' + '123',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
