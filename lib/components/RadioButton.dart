import 'package:flutter/material.dart';

enum keterangan { Izin, Sakit }

class RadioButton extends StatefulWidget {
  const RadioButton({super.key});

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  String groupValue = 'Izin';
  keterangan? _keterangan;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        SizedBox(width: 20),
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
    );
  }
}
