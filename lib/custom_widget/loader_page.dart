import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoaderPage extends StatefulWidget {
  @override
  AddPromptPageState createState() => AddPromptPageState();
}

class AddPromptPageState extends State<LoaderPage> {
  TextEditingController nameAlbumController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  List<Color> _kDefaultRainbowColors = [
    HexColor(CommonColor.pinkFont)

  ];
  @override
  Widget build(BuildContext context) {
    return animatedDialogueWithTextFieldAndButton(context);
  }

  animatedDialogueWithTextFieldAndButton(context) {
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        color: Color(0x66DD4D4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              height: 80,
              width: 200,
              child: Container(
                color: HexColor(CommonColor.pinkFont),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    Text('Loading...',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PR'),)
                  ],
                ),
              )
              // Material(
              //   color: Colors.transparent,
              //   child: LoadingIndicator(
              //     backgroundColor: Colors.transparent,
              //     indicatorType: Indicator.ballScale,
              //     colors: _kDefaultRainbowColors,
              //     strokeWidth: 4.0,
              //     pathBackgroundColor: Colors.yellow,
              //     // showPathBackground ? Colors.black45 : null,
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
