import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonWidget {
  showToaster({required String msg}) => Fluttertoast.showToast(
    msg: msg.toString(),
    textColor: Colors.black,
    backgroundColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );

  showErrorToaster({required String msg}) => Fluttertoast.showToast(

    msg: msg.toString(),
    textColor: Colors.white,
    backgroundColor: Colors.red,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}