import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
class KidsAccountDetails extends StatefulWidget {
  const KidsAccountDetails({Key? key}) : super(key: key);

  @override
  State<KidsAccountDetails> createState() => _KidsAccountDetialsState();
}

class _KidsAccountDetialsState extends State<KidsAccountDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Screen Time',
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
          child: ClipRRect(
              child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 0),
                child: Text('Screen Time',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor('#E84F90'),
                        fontFamily: 'PR')),
              ),
              SizedBox(height: 15),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Device unlocked',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'PR')),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            // stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              HexColor('#000000'),
                              HexColor('#C12265'),
                              HexColor('#FFFFFF'),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          AssetUtils.lock_icon,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: ListTile(
                  leading: Container(
                    child: Image.asset(
                      AssetUtils.dnd_icon,
                      height: 26,
                      width: 26,
                    ),
                  ),
                  title: Text('Bedtime',
                      style: TextStyle(
                          fontSize: 16,
                          color: HexColor(CommonColor.pinkFont),
                          fontFamily: 'PR')),
                  trailing: Text('9 PM - 7 AM',
                      style: TextStyle(
                          fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                ),
              ),
              Container(
                child: ListTile(
                  leading: Container(
                    child: Image.asset(
                      AssetUtils.alarm_icon,
                      height: 26,
                      width: 26,
                    ),
                  ),
                  title: Text('Bedtime',
                      style: TextStyle(
                          fontSize: 16,
                          color: HexColor(CommonColor.pinkFont),
                          fontFamily: 'PR')),
                  trailing: Text('9 PM - 7 AM',
                      style: TextStyle(
                          fontSize: 16, color: Colors.white, fontFamily: 'PR')),
                ),
              ),
              GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      double width = MediaQuery.of(context).size.width;
                      double height = MediaQuery.of(context).size.height;
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: AlertDialog(
                            backgroundColor: Colors.transparent,
                            contentPadding: EdgeInsets.zero,
                            elevation: 0.0,
                            // title: Center(child: Text("Evaluation our APP")),
                            content: Container(
                              height: 150,
                              // width: 133,
                              // padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(-1.0, 0.0),
                                    end: Alignment(1.0, 0.0),
                                    transform: GradientRotation(0.7853982),
                                    // stops: [0.1, 0.5, 0.7, 0.9],
                                    colors: [
                                      HexColor("#000000"),
                                      HexColor("#000000"),
                                      HexColor("##E84F90"),
                                      HexColor("#ffffff"),
                                      // HexColor("#FFFFFF").withOpacity(0.67),
                                    ],
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(26.0))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'John Mayers',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'PR',
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 28,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AssetUtils.lock_icon,
                                        height: 30,
                                        width: 22,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 16.81,
                                      ),
                                        Text(
                                        'Locked',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'PR',
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 28,),
                                  Text(
                                    'Unlock now',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'PR',
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            )),
                      );
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 27),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetUtils.lock_icon,
                          height: 30,
                          width: 22,
                          color: HexColor(CommonColor.pinkFont),
                        ),
                        SizedBox(
                          width: 16.81,
                        ),
                        Text('Lock Device Now',
                            style: TextStyle(
                                fontSize: 16,
                                color: HexColor(CommonColor.pinkFont),
                                fontFamily: 'PR'))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
