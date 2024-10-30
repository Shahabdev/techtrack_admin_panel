import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider extends ChangeNotifier {
  // Variable to store the internet connection status
  bool _hasInternet = false;

  // Getter for hasInternet
  bool get hasInternet => _hasInternet;

  // Constructor to check internet connection during initialization
  InternetProvider() {
    checkInternetConnection();
  }

  // Method to check the internet connection status
  Future checkInternetConnection() async {
    // Use the Connectivity package to check the device's connectivity status
    var result = await Connectivity().checkConnectivity();

    // Update _hasInternet based on the connectivity status
    _hasInternet = (result == ConnectivityResult.none) ? false : true;

    // Notify listeners that the data has changed
    notifyListeners();
  }
}
