import 'package:flutter/material.dart';

class HistoryComponent extends StatelessWidget {
  final label, jamMasuk;
  final IconData? icon;

  // Construktor
  const HistoryComponent({
    Key? key,
    required this.label,
    required this.jamMasuk,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      color: Colors.white,
      padding: const EdgeInsets.all(35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.purple[900]),
              ),
            ],
          ),
          // Mata Pelajaran
          Text(
            jamMasuk,
            style: TextStyle(
              fontSize: 16,
              color: Colors.purple[900],
            ),
          ),
          Icon(
            icon,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
