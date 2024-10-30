/*
  AuthProvider Class

  This Dart file defines the `AuthProvider` class, which is responsible for handling authentication-related functionalities, including sign-in, sign-up, and user data management.

  Dependencies:
  - dart:convert.
  - dart:math.
  - crypto package.
  - cloud_firestore package.
  - firebase_auth package.
  - provider package.
  - shared_preferences package.
  - LocationProvider class.

  Example Usage:
  - Create an instance of `AuthProvider` to use it for authentication and user data management.
  - Call the appropriate methods for sign-in, sign-up, and other operations.
  - Access user data using getter methods.

*/

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Functions/shared_prefrences_class.dart';

class AuthProvider extends ChangeNotifier {
  // instance of firebaseauth, facebook and google
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool _loading = false;

  get loading => _loading;
  void setLoading(bool value) {
    _loading = value;
    Future.microtask(() => notifyListeners());
  }

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  String? _email;
  String? get email => _email;

  String? _profileImage;
  String? get profileImage => _profileImage;

  String? _status;
  String? get status => _status;

  String generateRandomId(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final idList = List.generate(length, (index) => chars[random.nextInt(chars.length)]);
    return idList.join();
  }

  set isSignedIn(bool value) {
    _isSignedIn = value;
  }

  AuthProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  //SignUp
  Future signUpWithEmailPassword(
      BuildContext context,
      String name,
      String phoneNumber,
      String email,
      String password,
      ) async {
    UserCredential? userCredential;

    await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      _name = name;
      _phoneNumber = phoneNumber;
      _email = email;
      _profileImage = "https://avatar.iran.liara.run/public/boy?username=Ash";
      _uid = value.user!.uid;
    });

    notifyListeners();
  }

  //SignIn
  Future signInWithEmailAndPwd(context, String email, String password) async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance.collection('users').where("uid", isEqualTo: value.user!.uid).get();

        //print("This is document Data1 == ${result.docs[0]['password']}");
        if (result.docs.isNotEmpty) {
          final userDoc = result.docs[0];
          if (userDoc['uid'] == value.user!.uid) {
            _uid = userDoc['uid'];
            _name = userDoc['name'];
            _phoneNumber = userDoc['phoneNumber'];
            _email = userDoc['email'];
            _profileImage = userDoc['profile_image'];

            // Clear any previous error
            _hasError = false;
            _errorCode = "Welcome back! It's fantastic to see you again.";
            // openSnackBar(context, _errorCode, Colors.red);
            notifyListeners();
          } else {
            _hasError = true;
            _errorCode = "Uh-oh, it seems like we couldn't find a match for your credentials.";
            notifyListeners();
          }
          notifyListeners();
        } else {
          _hasError = true;
          _errorCode = "User not found or incorrect credentials";
          //openSnackBar(context, _errorCode, Colors.red);
          notifyListeners();
        }
      });
    } catch (e) {
      _hasError = true;
      print("Exception === $e");
      _errorCode = "it seems like we couldn't find a match for your credentials";
      // openSnackBar(context, _errorCode, Colors.red);
      notifyListeners();
    }
  }

//Forget password
  Future<bool> forgotPassword({email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException {
      // Handle password reset email failure, display an error message, etc.
      return false;
    }
  }

// ENTRY FOR CLOUDFIRESTORE
  Future getUserDataFromFirestore(uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then((DocumentSnapshot snapshot) => {
      _uid = snapshot['uid'],
      _name = snapshot['name'],
      _phoneNumber = snapshot['phoneNumber'],
      _email = snapshot['email'],
      _profileImage = snapshot['profile_image'],
    });
    notifyListeners();
  }

  Future saveDataToFirestore() async {
    final DocumentReference userCollection = FirebaseFirestore.instance.collection("users").doc(uid);
    await userCollection.set({
      "name": _name,
      "phoneNumber": _phoneNumber,
      "email": _email,
      "uid": _uid,
      "profile_image": _profileImage,
    });
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final s = LoginApiSharedPreference.preferences;
    await s!.setString('name', _name!);
    await s.setString('phoneNumber', _phoneNumber!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('profile_image', _profileImage!);
    notifyListeners();
  }

  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _phoneNumber = s.getString('phoneNumber');
    _email = s.getString('email');
    _profileImage = s.getString('profile_image');
    _uid = s.getString('uid');
    notifyListeners();
  }

  // checkUser exists or not in cloudfirestore
  Future<bool> checkUserExists() async {
    final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: email).get();
    if (result.docs.isNotEmpty) {
      print("EXISTING USER");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  // signout
  Future userSignOut() async {
    await firebaseAuth.signOut;

    _isSignedIn = false;
    clearStoredData();
    notifyListeners();
    // clear all storage information
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  Future deleteUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_uid).delete();
      print('User deleted successfully');
      clearStoredData();
      notifyListeners();
    } catch (e) {
      print('Error deleting user: $e');
      notifyListeners();
    }
  }
}
