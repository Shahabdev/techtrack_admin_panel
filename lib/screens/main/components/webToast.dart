import 'package:fluttertoast/fluttertoast.dart';

void webToast(String toast) {
  Fluttertoast.showToast(
    msg: toast,
    webPosition: "center",
    gravity: ToastGravity.TOP,
  );
}
