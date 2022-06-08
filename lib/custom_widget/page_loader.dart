import 'dart:typed_data';
import 'package:flutter/material.dart';


import 'loader_page.dart';
BuildContext? contexts;
showLoader(context,){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      contexts = context;
      return LoaderPage();

    },
  );
}

hideLoader(BuildContext context){
  Navigator.pop(contexts!);
}