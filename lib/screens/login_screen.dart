
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controllers/Functions/sign_in_function.dart';
import '../controllers/MenuAppController.dart';
import '../controllers/Provider/auth_provider.dart';
import 'main/components/webToast.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   TextEditingController emailController = TextEditingController();

   TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.text = "admin_tecktrack@gmail.com";
    passwordController.text = "123456789";
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      backgroundColor: bgColor,
      body: Consumer<AuthProvider>(builder: (BuildContext context, AuthProvider authProvider, child) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(20),
              width: 400,
              height: MediaQuery.of(context).size.height * 0.80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex:3,
                    child: Image.asset(
                      "assets/images/logo.png",
                    ),
                  ),
                  buildTextField(
                    emailController,
                    "Enter Email",
                    false,
                  ),
                  buildTextField(
                    passwordController,
                    "Enter Password",
                    true,
                  ),
                  Container(
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: InkWell(
                        onTap: () async {
                          if (emailController.text.isEmpty) {
                            webToast("Email cannot be blank");
                            return;
                          }
                          if (passwordController.text.isEmpty) {
                            webToast("Password cannot be blank");
                            return;
                          }
                          authProvider.setLoading(true);
                          await handleSignIn(context, emailController.text, passwordController.text);
                          authProvider.setLoading(false);
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: primaryColor,
                          ),
                          child: authProvider.loading
                              ? LoadingAnimationWidget.waveDots(
                            color: Colors.white,
                            size: 50,
                          )
                              : Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText, bool hide) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          obscureText: hide,
          controller: controller, // Assign the controller
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
