import 'package:flutter/material.dart';

// SnackBar which is accessible globally in the project
void openSnackBar(context, snackMessage, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: () {},
      ),
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 130, left: 5, right: 5),
      content: Text(
        snackMessage,
        style: const TextStyle(fontSize: 14),
      )));
}

// SnackBar which is accessible globally in the project
showSnackBar(context) {
  SnackBar snackBar = SnackBar(
    action: SnackBarAction(
      label: "OK",
      textColor: Colors.white,
      onPressed: () {},
    ),
    content: const Text('Ride request Rejected Something went wrong', style: TextStyle(fontSize: 16)),
    backgroundColor: Colors.redAccent,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 150, left: 5, right: 5),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
