import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/colorUtils.dart';
import '../Utils/custom_textfeild.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Help center',
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
          margin: EdgeInsets.symmetric(horizontal: 41),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  "Hi, How can we help you?",
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              Container(
                height: 45,
                margin: EdgeInsets.symmetric(vertical: 29),
                // width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                      spreadRadius: -5,
                    ),
                  ],
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 20, top: 14, bottom: 0),
                    alignLabelWithHint: false,
                    isDense: true,
                    hintText: "Search",
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide:
                    //   BorderSide(color: ColorUtils.blueColor, width: 1),
                    //   borderRadius: BorderRadius.all(Radius.circular(10)),
                    // ),
                    suffixIcon: IconButton(
                      color: HexColor(CommonColor.pinkFont),
                      icon: Icon(Icons.search),
                      iconSize: 25,
                      onPressed: () {},
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontFamily: 'PR',
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'PR',
                    color: Colors.white,
                  ),
                  // controller: controller,
                  keyboardType: TextInputType.text,
                ),
              ),
              ExpansionTile(
                iconColor: HexColor('#582338'),
                collapsedIconColor: HexColor('#582338'),
                title: Text(
                  "Question 1",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Answer 1",
                      style: TextStyle(
                          fontSize: 16,
                          color: HexColor('#707070'),
                          fontFamily: 'PR'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
