import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfileButton extends StatelessWidget {
  void Function()? onTap;
  final IconData? icon;
  final label;

  ProfileButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Icon(icon),
                      SizedBox(width: 10),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_right_alt),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
