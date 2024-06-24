import 'package:flutter/material.dart';

void showSuccessMessage(BuildContext context, {required String msg}) {
  final snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorMessage(BuildContext context, {required String msg}) {
  final snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
