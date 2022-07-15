import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';

import '../constants/app_constants.dart';
import '../constants/color_constants.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;

  FullPhotoPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // decoration: BoxDecoration(
          //
          //   image: DecorationImage(
          //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
          //     fit: BoxFit.cover,
          //   ),
          // ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("##330417"),
                HexColor("#000000"),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              AppConstants.fullPhotoTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PR',
                  fontSize: 16),
            ),
            centerTitle: true,
          ),
          body: Container(
            margin: EdgeInsets.only(top: 100,right: 30,left: 30),
            child: PhotoView(
              imageProvider: NetworkImage(url),
            ),
          ),
        ),
      ],
    );
  }
}
