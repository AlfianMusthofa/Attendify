import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final double? width, fontSize;
  final label;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Function()? onTap;
  final FontWeight? fontWeight;

  const MyButton({
    super.key,
    required this.width,
    required this.label,
    required this.padding,
    required this.borderRadius,
    required this.fontSize,
    required this.onTap,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        alignment: Alignment.center,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.purple[900],
          borderRadius: borderRadius,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DashboardButton extends StatelessWidget {
  final label;
  final imagePath;
  void Function()? onTap;

  DashboardButton({
    super.key,
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: 160,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: Colors.purple)),
          child: Center(
            child: Column(
              children: [
                // Logo
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(153, 132, 175, 248),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: 60,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardButton2 extends StatelessWidget {
  final label, jam;
  final void Function()? onTap;

  DashboardButton2({
    super.key,
    required this.label,
    required this.jam,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.purple,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(jam),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
