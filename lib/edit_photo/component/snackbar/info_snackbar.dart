import 'package:flutter/material.dart';


void showInfoSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black.withOpacity(0.8),
      content: Text(text),
    ),
  );
}
