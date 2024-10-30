import 'package:flutter/material.dart';

/*
This all function is for navigation Screens
 */

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenRemoveUntil(context, page) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    page,
    (route) => false,
  );
}
