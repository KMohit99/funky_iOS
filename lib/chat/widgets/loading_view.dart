import 'package:flutter/material.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';

import '../constants/color_constants.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          color:HexColor(CommonColor.pinkFont),
        ),
      ),
      color: Colors.black.withOpacity(0.8),
    );
  }
}
