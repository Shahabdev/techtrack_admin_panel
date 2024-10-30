
import 'package:flutter/material.dart';

import '../../screens/dashboard/dashboard_screen.dart';

class PageControllerProvider extends ChangeNotifier {

  Widget _currentPage = DashboardScreen();
  int _selectedIndex = 0;

  Widget get currentPage => _currentPage;
  int get selectedIndex => _selectedIndex;

  void setPage(Widget page) {
    _currentPage = page;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

}
