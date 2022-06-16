import 'package:flutter/material.dart';
import 'package:funky_new/Utils/asset_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({Key? key}) : super(key: key);

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen> {
  GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Scan',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            top: 0.0,
            bottom: 5.0,
          ),
          child: IconButton(
            onPressed: () {
          Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
              top: 0.0,
              bottom: 5.0,
            ),
            child: Container(
              height: 20.0,
              width: 20.0,
              child: Image.asset(AssetUtils.share_icon2),
            ),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 29,),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 29),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    color: Colors.lightBlue
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13.0,horizontal: 29),
                    child: Text(
                      'Color',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black, fontFamily: 'Pr'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 29),
                  child: Text(
                    'Friends can scan this to follow you.',
                    style: TextStyle(
                        fontSize: 16, color: Colors.white, fontFamily: 'PB'),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: () {
                    },
                    icon: Icon(Icons.arrow_downward,color: Colors.white,size: 50,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(26),
                  child: RepaintBoundary(
                    key: globalKey,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: QrImage(
                        data: 'Username!',
                        // size: 200,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.all(15),

                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
