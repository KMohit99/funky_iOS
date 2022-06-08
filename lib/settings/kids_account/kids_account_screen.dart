import 'package:flutter/material.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../custom_widget/common_buttons.dart';
import '../security_login/security_login.dart';
import 'kids_account_details_screen.dart';

class KidsAccount extends StatefulWidget {
  const KidsAccount({Key? key}) : super(key: key);

  @override
  State<KidsAccount> createState() => _KidsAccountState();
}

class _KidsAccountState extends State<KidsAccount> {
  String alarm_selected = 'alarm';
  bool valuesecond = false;
  bool isSwitched = false;

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      child: Text('Categories',
                          style: TextStyle(
                              fontSize: 16,
                              color: HexColor('#E84F90'),
                              fontFamily: 'PR')),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      child: Text('Need help?',
                          style: TextStyle(
                              fontSize: 16,
                              color: HexColor('#E84F90'),
                              fontFamily: 'PR')),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          alarm_selected = 'alarm';
                        });
                      },
                      child: Container(
                        height: 124,
                        width: 124,
                        decoration: BoxDecoration(
                            color: (alarm_selected == 'alarm'
                                ? HexColor(CommonColor.pinkFont)
                                : Colors.black),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 31.0, horizontal: 30),
                          child: Column(
                            children: [
                              Image.asset(
                                AssetUtils.alarm_icon,
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text('Daily limit',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'PR'))
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          alarm_selected = 'dnd';
                        });
                      },
                      child: Container(
                        height: 124,
                        width: 124,
                        decoration: BoxDecoration(
                            color: (alarm_selected == 'dnd'
                                ? HexColor(CommonColor.pinkFont)
                                : Colors.black),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 31.0, horizontal: 30),
                          child: Column(
                            children: [
                              Image.asset(
                                AssetUtils.dnd_icon,
                                height: 30,
                                width: 30,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text('Bedtime',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'PR'))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             Container(
               child:(alarm_selected == 'alarm'
                   ? alarm_widget()
                   :  dnt_widget()) ,
             )
            ],
          ),
        ),
      ),
    );
  }

  Widget alarm_widget(){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 33),
          height: 1,
          color: HexColor('#391B27'),
        ),
        Container(
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tuesday',
                    style: TextStyle(
                        fontSize: 15,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR')),
                Text('3 hr 15 min',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'PR')),
              ],
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      AssetUtils.plus_icon,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
                SizedBox(width: 25,),
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
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      AssetUtils.plus_icon,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 33),

          height: 1,
          color: HexColor('#391B27'),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Text('Tue',
                    style: TextStyle(
                        fontSize: 15,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR')),
              ),
              Flexible(
                flex: 2,
                child: Text('3hr',
                    style: TextStyle(
                        fontSize: 15,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR')),
              ),
              Flexible(
                flex: 2,
                child:  Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Checkbox(
                    checkColor: HexColor(CommonColor.pinkFont),
                    activeColor: Colors.black,
                    value: this.valuesecond,
                    onChanged: ( value) {
                      setState(() {
                        this.valuesecond = value!;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Text('Tue',
                    style: TextStyle(
                        fontSize: 15,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR')),
              ),
              Flexible(
                flex: 2,
                child: Text('3hr',
                    style: TextStyle(
                        fontSize: 15,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR')),
              ),
              Flexible(
                flex: 2,
                child:  Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Checkbox(
                    checkColor: HexColor(CommonColor.pinkFont),
                    activeColor: Colors.black,
                    value: this.valuesecond,
                    onChanged: ( value) {
                      setState(() {
                        this.valuesecond = value!;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 40,horizontal: 60),
          child: common_button(
            onTap: () {
              Get.to(KidsAccountDetails());
              // selectTowerBottomSheet(context);
              // _kids_loginScreenController.ParentEmailVerification(context);
            },
            backgroud_color: Colors.white,
            lable_text: 'Save',
            lable_text_color: Colors.black,
          ),
        ),
      ],
    );
  }
  List days= [
    "S",
    "M",
    "T",
    "W",
    "T",
    "F",
    "S",
  ];

  Widget dnt_widget(){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 33),
          height: 1,
          color: HexColor('#391B27'),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text('Scheduled',
                    style: TextStyle(
                        fontSize: 15,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR')),
              ),
              Container(
                child: Theme(
                  data: ThemeData(
                      unselectedWidgetColor: HexColor(CommonColor.pinkFont)
                  ),
                  child: Switch(

                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    activeColor: HexColor(CommonColor.pinkFont),
                    inactiveTrackColor: Colors.red[100],
                    inactiveThumbColor: HexColor(CommonColor.pinkFont),
                  ),
                ),
              )
            ],
          ),
        ),
        ListView.builder(
          itemCount: days.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context ,int index){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      child: Container(
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
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 6),
                          child: Text(days[index],
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontFamily: 'PR')),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child:  Text('9 PM - 7 AM',
                          style: TextStyle(
                              fontSize: 15,
                              color: HexColor(CommonColor.pinkFont),
                              fontFamily: 'PR')),
                    ),
                  ),

                ],
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 40,horizontal: 60),
          child: common_button(
            onTap: () {
              Get.to(KidsAccountDetails());
              // selectTowerBottomSheet(context);
              // _kids_loginScreenController.ParentEmailVerification(context);
            },
            backgroud_color: Colors.white,
            lable_text: 'Save',
            lable_text_color: Colors.black,
          ),
        ),

      ],
    );
  }
}
