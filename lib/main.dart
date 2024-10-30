
import 'package:admin_dash/screens/login_screen.dart';
import 'package:admin_dash/screens/main/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'controllers/Functions/shared_prefrences_class.dart';
import 'controllers/MenuAppController.dart';
import 'controllers/Provider/auth_provider.dart';
import 'controllers/Provider/internet_provider.dart';
import 'controllers/Provider/page_controller.dart';
import 'controllers/Provider/users_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoginApiSharedPreference.getInit();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuAppController()),
        ChangeNotifierProvider(create: (context) => InternetProvider()),
        ChangeNotifierProvider(create: (context) => PageControllerProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TechTrack Panel',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        routes: {
          '/home': (context) => MainScreen(),
          '/signIn': (context) => LoginScreen(),
        },
        home: Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider authProvider, child) {
          authProvider.getDataFromSharedPreferences();
          return authProvider.isSignedIn ? MainScreen() : LoginScreen();
        }),
      ),
    );
  }
}
