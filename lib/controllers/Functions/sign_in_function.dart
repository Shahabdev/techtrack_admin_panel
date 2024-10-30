// handling google sign in
// here if user exist the login other sign up the user

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/main/components/webToast.dart';
import '../Provider/auth_provider.dart';
import '../Provider/internet_provider.dart';

Future handleSignIn(
  BuildContext context,
  String email,
  String password,
) async {
  final sp = context.read<AuthProvider>();
  final ip = context.read<InternetProvider>();
  await ip.checkInternetConnection();
  sp.setLoading(true);

  if (ip.hasInternet == false) {
    webToast(
      "Check your Internet connection",
    );
    sp.setLoading(false);
  } else {
    await sp
        .signInWithEmailAndPwd(
      context,
      email,
      password,
    )
        .then((value) async {
      if (sp.hasError == true) {
        print("error ---->${sp.hasError}");
        webToast(
          sp.errorCode.toString(),
        );
      } else {
        // checking whether user exists or not
        await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
            .saveDataToSharedPreferences()
            .then((value) => sp.setSignIn().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                })));
      }
    });
  }
}
