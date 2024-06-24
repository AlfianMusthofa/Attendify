import 'package:flutter/material.dart';

class PersonalInformation extends StatelessWidget {
  final name, imagePath, kelas;
  const PersonalInformation({
    Key? key,
    required this.name,
    required this.kelas,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Column(
            children: [
              // image person
              ClipOval(
                child: Image.asset(
                  imagePath,
                  width: 120,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                // personalInformationModel.name,
                name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                kelas + ' - ' + '1234',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
