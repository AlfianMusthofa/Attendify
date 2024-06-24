import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final bool obscureText;
  final label;
  final controller;

  const InputField({
    super.key,
    required this.label,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Colors.black38,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          label: Text(label),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(18),
        ),
      ),
    );
  }
}
