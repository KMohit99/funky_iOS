import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_textfeild.dart';
import '../custom_widget/common_buttons.dart';

class ReportProblem extends StatefulWidget {
  const ReportProblem({Key? key}) : super(key: key);

  @override
  State<ReportProblem> createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Report a Problem',
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
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Container(
                child: Text(
                  "Briefly explain what happened or what's not working.",
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              SizedBox(
                height: 23,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 18),
                    child: Text(
                      'Write',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PR',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Container(
                    // height: 45,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: TextFormField(
                      maxLines: 5,
                      // onTap: tap,
                      obscureText: false,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 20, top: 14, bottom: 14),
                        alignLabelWithHint: false,
                        isDense: true,
                        hintText: 'Write the problem you faced',
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide:
                        //   BorderSide(color: ColorUtils.blueColor, width: 1),
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        // ),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'PR',
                          color: Colors.grey,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PR',
                        color: Colors.black,
                      ),
                      // controller: controller,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                child: Text(
                  "Please only leave feedback about Funky and our features",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor('#BCBCBC'),
                      fontFamily: 'PR'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      // height: 45,
                      // width:(width ?? 300) ,
                      decoration: BoxDecoration(
                          color: HexColor(CommonColor.pinkFont),
                          borderRadius: BorderRadius.circular(25)),
                      child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            vertical: 12,horizontal: 25
                          ),
                          child: Text(
                            "Attach",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'PR',
                                fontSize: 16),
                          )),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Attach screenshot or image",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: HexColor(CommonColor.pinkFont),
                          fontFamily: 'PR'),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: FractionalOffset.bottomCenter,
                margin: EdgeInsets.symmetric(vertical: 100),
                child: common_button(
                  lable_text: 'Submit',
                  backgroud_color: Colors.white,
                  lable_text_color: Colors.black,
                  onTap: (){},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
