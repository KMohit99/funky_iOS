import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:funky_project/Authentication/creator_signup/model/countryModelclass.dart';
// import 'package:funky_project/controller/controllers_class.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchfield/searchfield.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../Utils/App_utils.dart';
import '../../../custom_widget/common_buttons.dart';
import '../controller/creator_signup_controller.dart';
import '../model/CountryModel.dart';
import '../model/countryModelclass.dart';

class Creator_signup extends StatefulWidget {
  const Creator_signup({Key? key}) : super(key: key);

  @override
  State<Creator_signup> createState() => _Creator_signupState();
}

class _Creator_signupState extends State<Creator_signup> {
  final Creator_signup_controller _creator_signup_controller = Get.put(
      Creator_signup_controller(),
      tag: Creator_signup_controller().toString());
  final List<String> data = <String>[
    'male',
    'female',
  ];
  List<Data_country> data2 = <Data_country>[];
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await _creator_signup_controller.getAllCountriesFromAPI();
  }

  File? imgFile;
  final imgPicker = ImagePicker();

  void openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      _creator_signup_controller.photoBase64 =
          base64Encode(imgFile!.readAsBytesSync());
      print("imgFile! ${imgFile}");
      // print(_creator_signup_controller.photoBase64);

      final bytes = Io.File(imgCamera.path).readAsBytesSync();
      _creator_signup_controller.img64 = base64Encode(bytes);
      print(_creator_signup_controller.img64!.substring(0, 100));
    });
    Navigator.of(context).pop();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
      _creator_signup_controller.photoBase64 =
          base64Encode(imgFile!.readAsBytesSync());
      print(_creator_signup_controller.photoBase64);

      final bytes = Io.File(imgGallery.path).readAsBytesSync();
      _creator_signup_controller.img64 = base64Encode(bytes);
      print(_creator_signup_controller.img64!.substring(0, 100));
    });
    Navigator.of(context).pop();
  }

  // Uint8List bytes = BASE64.decode(_base64);
  // Image.memory(bytes),
  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetBuilder<Creator_signup_controller>(
        init: _creator_signup_controller,
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
                    'Creator Signup',
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
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: common_button(
                                                    onTap: () {
                                                      openCamera();
                                                      // Get.toNamed(BindingUtils.signupOption);
                                                    },
                                                    backgroud_color:
                                                        Colors.black,
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
                                                  lable_text_color:
                                                      Colors.white,
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
                          // SizedBox(
                          //   height: 80,
                          //   width: 80,
                          //   child: (imgFile == null ? IconButton(
                          //     icon: Image.asset(
                          //       AssetUtils.user_icon,
                          //       fit: BoxFit.fill,
                          //     ),
                          //     onPressed: () {
                          //       showDialog(
                          //         context: context,
                          //         builder: (ctx) => AlertDialog(
                          //
                          //           title: Text("Pick Image from"),
                          //           actions: <Widget>[
                          //             Container(
                          //               margin: EdgeInsets.only(bottom: 10),
                          //               child: common_button(
                          //                 onTap: () {
                          //                   openCamera();
                          //                   // Get.toNamed(BindingUtils.signupOption);
                          //                 },
                          //                 backgroud_color: Colors.black,
                          //                 lable_text: 'Camera',
                          //                 lable_text_color: Colors.white,
                          //               ),
                          //             ),
                          //
                          //             common_button(
                          //               onTap: () {
                          //                openGallery();
                          //                 // Get.toNamed(BindingUtils.signupOption);
                          //               },
                          //               backgroud_color: Colors.black,
                          //               lable_text: 'Gallery',
                          //               lable_text_color: Colors.white,
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     },
                          //   ) : Image.file(imgFile!, fit: BoxFit.fill,)
                          // ),
                          // ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CommonTextFormField(
                          height: 45,
                          title: TxtUtils.FullName,
                          controller:
                              _creator_signup_controller.fullname_controller,
                          labelText: "Enter full name",
                          image_path: AssetUtils.human_icon,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CommonTextFormField(
                          height: 45,
                          title: TxtUtils.UserName,
                          controller:
                              _creator_signup_controller.username_controller,
                          labelText: "Enter username",
                          image_path: AssetUtils.human_icon,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CommonTextFormField(
                          height: 45,
                          title: TxtUtils.Email,
                          controller:
                              _creator_signup_controller.email_controller,
                          labelText: "Enter Email",
                          image_path: AssetUtils.msg_icon,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
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

                              // Container(
                              //   height: 45,
                              //   width: 300,
                              //   decoration: BoxDecoration(
                              //     boxShadow: const [
                              //       BoxShadow(
                              //         color: Colors.black,
                              //         blurRadius: 5,
                              //         offset: Offset(0, 0),
                              //         spreadRadius: -5,
                              //       ),
                              //     ],
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(24.0),
                              //   ),
                              //   child: FormField<String>(
                              //     builder: (FormFieldState<String> state) {
                              //       return DropdownButtonHideUnderline(
                              //         child: DropdownButton2(
                              //           isExpanded: true,
                              //           hint: Row(
                              //             children: [
                              //               SizedBox(
                              //                 width: 4,
                              //               ),
                              //               Expanded(
                              //                 child: Text(
                              //                   'Select location',
                              //                   style: TextStyle(
                              //                     fontSize: 14,
                              //                     fontFamily: 'PR',
                              //                     color: Colors.grey,
                              //                   ),
                              //                   overflow: TextOverflow.ellipsis,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           items: _creator_signup_controller
                              //               .data_country
                              //               .map((CountryList item) =>
                              //                   DropdownMenuItem<CountryList>(
                              //                     value: item,
                              //                     child: Text(
                              //                       '${item.name}',
                              //                       style: TextStyle(
                              //                         fontSize: 16,
                              //                         fontFamily: 'PR',
                              //                         color: Colors.pink,
                              //                       ),
                              //                       overflow:
                              //                           TextOverflow.ellipsis,
                              //                     ),
                              //                   ))
                              //               .toList(),
                              //           value: _creator_signup_controller
                              //               .selectedcountry,
                              //           style: TextStyle(
                              //             fontSize: 16,
                              //             fontFamily: 'PR',
                              //             color: Colors.white,
                              //           ),
                              //           onChanged: (value) {
                              //             setState(() {
                              //               _creator_signup_controller
                              //                       .selectedcountry =
                              //                   value as CountryList?;
                              //             });
                              //             // print(contactdetailsController
                              //             //     .selectedValue);
                              //           },
                              //           iconSize: 25,
                              //           icon: Image.asset(
                              //             AssetUtils.downArrow_icon,
                              //             height: 13,
                              //             width: 13,
                              //           ),
                              //           iconEnabledColor: Color(0xff007DEF),
                              //           iconDisabledColor: Color(0xff007DEF),
                              //           buttonHeight: 50,
                              //           buttonWidth: 160,
                              //           buttonPadding: const EdgeInsets.only(
                              //               left: 15, right: 15),
                              //           buttonDecoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(10),
                              //               color: Colors.transparent),
                              //           buttonElevation: 0,
                              //           itemHeight: 40,
                              //           itemPadding: const EdgeInsets.only(
                              //               left: 14, right: 14),
                              //           dropdownMaxHeight: 200,
                              //           dropdownPadding: null,
                              //           dropdownDecoration: BoxDecoration(
                              //             borderRadius:
                              //                 BorderRadius.circular(24),
                              //             border: Border.all(
                              //                 width: 1, color: Colors.white),
                              //             gradient: LinearGradient(
                              //               begin: Alignment.topLeft,
                              //               end: Alignment.bottomRight,
                              //               // stops: [0.1, 0.5, 0.7, 0.9],
                              //               colors: [
                              //                 HexColor("#000000"),
                              //                 HexColor("#C12265"),
                              //                 HexColor("#C12265"),
                              //                 HexColor("#FFFFFF"),
                              //               ],
                              //             ),
                              //           ),
                              //           dropdownElevation: 8,
                              //           scrollbarRadius:
                              //               const Radius.circular(40),
                              //           scrollbarThickness: 6,
                              //           scrollbarAlwaysShow: true,
                              //           offset: const Offset(0, -5),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                              SizedBox(
                                height: 11,
                              ),
                              Container(
                                // height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white,width: 1),
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
                                child: SearchField(
                                  autoCorrect: true,
                                  controller: _creator_signup_controller.location_controller,
                                  suggestions: _creator_signup_controller
                                      .data_country
                                      .map((e) => SearchFieldListItem(e.name!,
                                          child: Text(
                                            e.name!,
                                            style: TextStyle(color: Colors.white),
                                          )))
                                      .toList(),

                                  suggestionState: Suggestion.expand,
                                  textInputAction: TextInputAction.next,
                                  // hint: 'SearchField Example 2',

                                  hasOverlay: false,
                                  searchStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'PR',
                                    color: Colors.black,
                                  ),
                                  // controller: ,
                                  validator: (x) {
                                    if (!_creator_signup_controller.data_country
                                            .contains(x) ||
                                        x!.isEmpty) {
                                      return 'Please Enter a valid State';
                                    }
                                    return null;
                                  },
                                  searchInputDecoration: InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Search Country',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'PR',
                                      color: Colors.grey,
                                    ),
                                    contentPadding: EdgeInsets.all(14),
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                    ),
                                    enabledBorder: InputBorder.none,
                                  ),

                                  suggestionsDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(24),
                                        bottomRight: Radius.circular(24)),
                                    color: Colors.white,
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
                                  // maxSuggestionsInViewPort: 6,
                                  itemHeight: 45,
                                  onSuggestionTap: (x) {
                                    print(_creator_signup_controller.location_controller.text);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CommonTextFormField(
                          height: 45,
                          title: TxtUtils.phone,
                          controller:
                              _creator_signup_controller.phone_controller,
                          labelText: "Enter phone no",
                          image_path: AssetUtils.phone_icon,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CommonTextFormField(
                          height: 45,
                          title: TxtUtils.Password,
                          controller:
                              _creator_signup_controller.password_controller,
                          labelText: 'Enter password',
                          image_path: AssetUtils.key_icon,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        // CommonTextFormField(
                        //   height: 45,
                        //   title: TxtUtils.parents_email,
                        //   controller:
                        //       _creator_signup_controller.parentEmail_controller,
                        //   labelText: TxtUtils.parents_email,
                        //   image_path: AssetUtils.msg_icon,
                        // ),
                        // SizedBox(
                        //   height: 12,
                        // ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 18),
                                child: Text(
                                  "Gender",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'PR',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              // Container(
                              //   height: 45,
                              //   width: 300,
                              //   decoration: BoxDecoration(
                              //     boxShadow: const [
                              //       BoxShadow(
                              //         color: Colors.black,
                              //         blurRadius: 5,
                              //         offset: Offset(0, 0),
                              //         spreadRadius: -5,
                              //       ),
                              //     ],
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(24.0),
                              //   ),
                              //   child: FormField<String>(
                              //     builder: (FormFieldState<String> state) {
                              //       return DropdownButtonHideUnderline(
                              //         child: DropdownButton2(
                              //           isExpanded: true,
                              //           hint: Row(
                              //             children: [
                              //               SizedBox(
                              //                 width: 4,
                              //               ),
                              //               Expanded(
                              //                 child: Text(
                              //                   'Select gender',
                              //                   style: TextStyle(
                              //                     fontSize: 14,
                              //                     fontFamily: 'PR',
                              //                     color: Colors.grey,
                              //                   ),
                              //                   overflow: TextOverflow.ellipsis,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //
                              //           items: data
                              //               .map((item) =>
                              //                   DropdownMenuItem<String>(
                              //                     value: item,
                              //                     child: Text(
                              //                       item,
                              //                       style: TextStyle(
                              //                         fontSize: 16,
                              //                         fontFamily: 'PR',
                              //                         color: Colors.pink,
                              //                       ),
                              //                       overflow:
                              //                           TextOverflow.ellipsis,
                              //                     ),
                              //                   ))
                              //               .toList(),
                              //           value: _creator_signup_controller
                              //               .selected_gender,
                              //           onChanged: (value) {
                              //             setState(() {
                              //               _creator_signup_controller
                              //                       .selected_gender =
                              //                   value as String;
                              //             });
                              //             // print(contactdetailsController
                              //             //     .selectedValue);
                              //           },
                              //           style: TextStyle(
                              //             fontSize: 16,
                              //             fontFamily: 'PR',
                              //             color: Colors.black,
                              //           ),
                              //           iconSize: 25,
                              //           icon: Image.asset(
                              //             AssetUtils.downArrow_icon,
                              //             height: 13,
                              //             width: 13,
                              //           ),
                              //           iconEnabledColor: Color(0xff007DEF),
                              //           iconDisabledColor: Color(0xff007DEF),
                              //           buttonHeight: 50,
                              //           buttonWidth: 160,
                              //           buttonPadding: const EdgeInsets.only(
                              //               left: 15, right: 15),
                              //           buttonDecoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(10),
                              //               color: Colors.transparent),
                              //           buttonElevation: 0,
                              //           itemHeight: 40,
                              //           itemPadding: const EdgeInsets.only(
                              //               left: 14, right: 14),
                              //           dropdownMaxHeight: 200,
                              //           dropdownPadding: null,
                              //           dropdownDecoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(24),
                              //             border: Border.all(
                              //                 width: 1, color: Colors.white),
                              //             gradient: LinearGradient(
                              //               begin: Alignment.topLeft,
                              //               end: Alignment.bottomRight,
                              //               // stops: [0.1, 0.5, 0.7, 0.9],
                              //               colors: [
                              //                 HexColor("#000000"),
                              //                 HexColor("#C12265"),
                              //                 HexColor("#C12265"),
                              //                 HexColor("#FFFFFF"),
                              //               ],
                              //             ),
                              //           ),
                              //           dropdownElevation: 8,
                              //           scrollbarRadius:
                              //               const Radius.circular(40),
                              //           scrollbarThickness: 6,
                              //           scrollbarAlwaysShow: true,
                              //           offset: const Offset(0, -5),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                              Container(
                                // height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white,width: 1),
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
                                child: SearchField(
                                  autoCorrect: true,
                                  controller: _creator_signup_controller.gender_controller,
                                  suggestions: data
                                      .map((e) => SearchFieldListItem(e,
                                      child: Text(
                                        e,
                                        style: TextStyle(color: Colors.white),
                                      )))
                                      .toList(),

                                  suggestionState: Suggestion.expand,
                                  textInputAction: TextInputAction.next,
                                  // hint: 'SearchField Example 2',

                                  hasOverlay: false,
                                  searchStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'PR',
                                    color: Colors.black,
                                  ),
                                  // controller: ,
                                  validator: (x) {
                                    if (_creator_signup_controller.selected_gender!.isEmpty) {
                                      return 'Please Enter a valid State';
                                    }
                                    return null;
                                  },
                                  searchInputDecoration: InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Select gender',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'PR',
                                      color: Colors.grey,
                                    ),
                                    contentPadding: EdgeInsets.all(14),
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                    ),
                                    enabledBorder: InputBorder.none,
                                  ),

                                  suggestionsDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(24),
                                        bottomRight: Radius.circular(24)),
                                    color: Colors.white,
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
                                  // maxSuggestionsInViewPort: 6,
                                  itemHeight: 45,
                                  onSuggestionTap: (x) {
                                    print(_creator_signup_controller.gender_controller.text);
                                  },
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CommonTextFormField(
                          height: 45,
                          title: TxtUtils.ReffrelCode,
                          controller:
                              _creator_signup_controller.reffralCode_controller,
                          labelText: "Enter Referral code",
                          image_path: AssetUtils.human_icon,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CommonTextFormField(
                          height: 45,
                          title: TxtUtils.CountryCode,
                          controller:
                              _creator_signup_controller.countryCode_controller,
                          labelText: TxtUtils.CountryCode,
                          image_path: AssetUtils.human_icon,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CommonTextFormField_text(
                          maxLines: 4,
                          title: TxtUtils.AboutMe,
                          controller:
                              _creator_signup_controller.aboutMe_controller,
                          labelText: "Enter about YourSelf(150 char)",
                          image_path: AssetUtils.human_icon,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white),
                              child: Checkbox(
                                checkColor: Colors.black,
                                activeColor: Colors.white,
                                value: valuefirst,
                                onChanged: (value) {
                                  setState(() {
                                    valuefirst = value!;
                                  });
                                },
                              ),
                            ),
                            Container(
                              child: Text(
                                'I agree Terms & Conditions',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'PR',
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        common_button(
                          onTap: () {
                            _creator_signup_controller.creator_signup(context);
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
      ),
    );
  }
}

class MenuItem {
  final String text;

  const MenuItem({
    required this.text,
  });
}
