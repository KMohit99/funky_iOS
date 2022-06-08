import 'dart:convert';
import 'dart:io';
import 'dart:io'as Io;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:funky_project/Authentication/creator_signup/model/countryModelclass.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../custom_widget/common_buttons.dart';
import '../../creator_login/controller/creator_login_controller.dart';
import '../../creator_signup/model/countryModelclass.dart';
import '../controller/kids_signup_controller.dart';

class KidSignupScreen extends StatefulWidget {
  const KidSignupScreen({Key? key}) : super(key: key);

  @override
  State<KidSignupScreen> createState() => _KidSignupScreenState();
}

class _KidSignupScreenState extends State<KidSignupScreen> {
  final Kids_signup_controller _kids_signup_controller = Get.put(
      Kids_signup_controller(),
      tag: Kids_signup_controller().toString());


  final List<String> data = <String>[
    'male',
    'female',
  ];
  List<Data_country> data2 = <Data_country>[];

  @override
  void initState() {
    init();
    super.initState();
  }
  init() async {
    await _kids_signup_controller.getAllCountriesFromAPI();
  }

  File? imgFile;
  final imgPicker = ImagePicker();

  void openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      _kids_signup_controller.photoBase64 =
          base64Encode(imgFile!.readAsBytesSync());
      print(_kids_signup_controller.photoBase64);

      final bytes = Io.File(imgCamera.path).readAsBytesSync();
      _kids_signup_controller.img64 = base64Encode(bytes);
      print(_kids_signup_controller.img64!.substring(0, 100));
    });
    Navigator.of(context).pop();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
      _kids_signup_controller.photoBase64 =
          base64Encode(imgFile!.readAsBytesSync());
      print(_kids_signup_controller.photoBase64);

      final bytes = Io.File(imgGallery.path).readAsBytesSync();
      _kids_signup_controller.img64 = base64Encode(bytes);
      print(_kids_signup_controller.img64!.substring(0, 100));
    });
    Navigator.of(context).pop();
  }

  // Uint8List bytes = BASE64.decode(_base64);
  // Image.memory(bytes),

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GetBuilder<Kids_signup_controller>(
      init: _kids_signup_controller,
      builder: (GetxController controller) {
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
                    HexColor("#000000").withOpacity(0.67),
                    HexColor("#000000").withOpacity(0.67),
                    HexColor("#C12265").withOpacity(0.67),
                    HexColor("#FFFFFF").withOpacity(0.67),
                  ],
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: AssetImage(
                    AssetUtils.backgroundImage2,
                  ),
                ),
              ),
            ),
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'Kids Signup',
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'PB', color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              // <-- SCAFFOLD WITH TRANSPARENT BG
              body: Container(
                width: screenwidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Container(
                          height: 80,
                          width: 80,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: (imgFile == null
                                  ? IconButton(
                                      icon: Image.asset(
                                        AssetUtils.user_icon,
                                        fit: BoxFit.fill,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text("Pick Image from"),
                                            actions: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                child: common_button(
                                                  onTap: () {
                                                    openCamera();
                                                    // Get.toNamed(BindingUtils.signupOption);
                                                  },
                                                  backgroud_color: Colors.black,
                                                  lable_text: 'Camera',
                                                  lable_text_color:
                                                      Colors.white,
                                                ),
                                              ),
                                              common_button(
                                                onTap: () {
                                                  openGallery();
                                                  // Get.toNamed(BindingUtils.signupOption);
                                                },
                                                backgroud_color: Colors.black,
                                                lable_text: 'Gallery',
                                                lable_text_color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Image.file(
                                      imgFile!,
                                      fit: BoxFit.fill,
                                    ))),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CommonTextFormField(
                        title: TxtUtils.UserName,
                        controller: _kids_signup_controller.username_controller,
                        labelText: "Enter username",
                        image_path: AssetUtils.human_icon,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CommonTextFormField(
                        title: TxtUtils.FullName,
                        controller: _kids_signup_controller.fullname_controller,
                        labelText: "Enter Fullname",
                        image_path: AssetUtils.human_icon,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CommonTextFormField(
                        title: TxtUtils.Email,
                        controller: _kids_signup_controller.email_controller,
                        labelText: "Enter Email",
                        image_path: AssetUtils.msg_icon,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CommonTextFormField(
                        title: TxtUtils.Password,
                        controller: _kids_signup_controller.password_controller,
                        labelText: 'Enter password',
                        image_path: AssetUtils.key_icon,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 18),
                            child: Text(
                              "Location",
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
                            height: 45,
                            width: 300,
                            decoration: BoxDecoration(
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
                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Row(
                                      children: [
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Select location',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'PR',
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: (_kids_signup_controller
                                                    .iscountryLoading.value ==
                                                true
                                            ? data2
                                            : _kids_signup_controller
                                                .data_country)
                                        .map((Data_country item) =>
                                            DropdownMenuItem<Data_country>(
                                              value: item,
                                              child: Text(
                                                '${item.location}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'PR',
                                                  color: Colors.pink,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    value:
                                        _kids_signup_controller.selectedcountry,
                                    onChanged: (value) {
                                      setState(() {
                                        _kids_signup_controller
                                                .selectedcountry =
                                            value as Data_country?;
                                      });
                                      // print(contactdetailsController
                                      //     .selectedValue);
                                    },
                                    iconSize: 25,
                                    icon: Image.asset(
                                      AssetUtils.downArrow_icon,
                                      height: 13,
                                      width: 13,
                                    ),
                                    iconEnabledColor: Color(0xff007DEF),
                                    iconDisabledColor: Color(0xff007DEF),
                                    buttonHeight: 50,
                                    buttonWidth: 160,
                                    buttonPadding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    buttonDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.transparent),
                                    buttonElevation: 0,
                                    itemHeight: 40,
                                    itemPadding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    dropdownMaxHeight: 200,
                                    dropdownPadding: null,
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        // stops: [0.1, 0.5, 0.7, 0.9],
                                        colors: [
                                          HexColor("#000000"),
                                          HexColor("#C12265"),
                                          HexColor("#C12265"),
                                          HexColor("#FFFFFF"),
                                        ],
                                      ),
                                    ),
                                    dropdownElevation: 8,
                                    scrollbarRadius: const Radius.circular(40),
                                    scrollbarThickness: 6,
                                    scrollbarAlwaysShow: true,
                                    offset: const Offset(0, -5),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CommonTextFormField(
                        title: TxtUtils.phone,
                        controller: _kids_signup_controller.phone_controller,
                        labelText: "Enter phone no",
                        image_path: AssetUtils.phone_icon,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CommonTextFormField_text(
                        maxLines: 4,
                        title: TxtUtils.AboutMe,
                        controller: _kids_signup_controller.aboutMe_controller,
                        labelText: "Enter about YourSelf(150 char)",
                        image_path: AssetUtils.human_icon,
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      common_button(
                        onTap: () {
                          _kids_signup_controller.kids_signup(context);
                          // Get.toNamed(BindingUtils.signupOption);
                        },
                        backgroud_color: Colors.black,
                        lable_text: 'Next',
                        lable_text_color: Colors.white,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
