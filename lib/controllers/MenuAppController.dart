import 'package:flutter/material.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _globalKey;

   void controlMenu() {
    print("value---->");
    if (!_globalKey.currentState!.isDrawerOpen) {
      print("enter here--->");
      _globalKey.currentState!.openDrawer();
    }

  }
}
