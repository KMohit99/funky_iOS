import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/dashboard/dashboard_screen.dart';
import 'package:funky_new/profile_screen/profile_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../Utils/App_utils.dart';
import '../../Utils/asset_utils.dart';
import '../../Utils/custom_textfeild.dart';
import '../../Utils/toaster_widget.dart';
import '../../custom_widget/common_buttons.dart';
import '../../sharePreference.dart';
import '../Utils/colorUtils.dart';

class PostImagePreviewScreen extends StatefulWidget {
  final File ImageFile;

  const PostImagePreviewScreen({Key? key, required this.ImageFile,})
      : super(key: key);

  @override
  State<PostImagePreviewScreen> createState() => _PostImagePreviewScreenState();
}

class _PostImagePreviewScreenState extends State<PostImagePreviewScreen> {
  bool valuefirst = false;
  TextEditingController description_controller = new TextEditingController();

  share_icon() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Pick Image from"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: common_button(
              onTap: () {
                uploadImage();
                // Get.toNamed(BindingUtils.signupOption);
              },
              backgroud_color: Colors.black,
              lable_text: 'Share',
              lable_text_color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

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
                HexColor("#000000").withOpacity(0.67),
                HexColor("#000000").withOpacity(0.67),
                HexColor("#C12265").withOpacity(0.67),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Edit Post',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'PB'),
            ),
            centerTitle: true,
            leadingWidth: 100,
            leading: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  print('oject');
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                )),
            actions: [
              InkWell(
                onTap: () {
                  share_icon();
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    AssetUtils.share_icon,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // width: 300,
                    child: TextFormField(
                      maxLength: 150,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 20, top: 14, bottom: 14),
                        alignLabelWithHint: false,
                        isDense: true,
                        labelText: 'Add Description',
                        counterStyle: TextStyle(
                          height: double.minPositive,
                        ),
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffE84F90)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffE84F90),
                          ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'PR',
                          color: Color(0xffE84F90),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PR',
                        color: Colors.white,
                      ),
                      controller: description_controller,
                      // keyboardType: keyboardType ?? TextInputType.multiline,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Tag People',
                      style: TextStyle(
                          fontSize: 14, fontFamily: 'PR', color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Location',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PR',
                              color: HexColor(CommonColor.pinkFont)),
                        ),
                        Container(
                          child: Icon(
                            Icons.gps_fixed,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enable Download',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PR',
                              color: Colors.white),
                        ),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            visualDensity:
                                VisualDensity(vertical: -4, horizontal: -4),
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            value: valuefirst,
                            onChanged: (value) {
                              setState(() {
                                valuefirst = value!;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enable Comments',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PR',
                              color: Colors.white),
                        ),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            visualDensity:
                                VisualDensity(vertical: -4, horizontal: -4),
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            value: valuefirst,
                            onChanged: (value) {
                              setState(() {
                                valuefirst = value!;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enable save to device',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PR',
                              color: Colors.white),
                        ),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            visualDensity:
                                VisualDensity(vertical: -4, horizontal: -4),
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            value: valuefirst,
                            onChanged: (value) {
                              setState(() {
                                valuefirst = value!;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Image.file(
                      widget.ImageFile,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // bool ispostLoading = false;
  // PostModelList? _postModelList;

  // Future<dynamic> Share_image_api(BuildContext context) async {
  //   setState(() {
  //     ispostLoading = true;
  //   });
  //   // showLoader(context);
  //
  //   String id_user = await PreferenceManager().getPref(URLConstants.id);
  //
  //   debugPrint('0-0-0-0-0-0-0 username');
  //   Map data = {
  //     'userId': id_user,
  //     'description': description_controller.text,
  //     'trending': '#image',
  //     'image': widget.ImageFile.readAsBytesSync(),
  //     'uploadVideo': '',
  //     'isVideo': 'false',
  //   };
  //   print(data);
  //   // String body = json.encode(data);
  //
  //   var url = (URLConstants.base_url + URLConstants.postApi);
  //   print("url : $url");
  //   print("body : $data");
  //
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: data,
  //   );
  //   print(response.body);
  //   print(response.request);
  //   print(response.statusCode);
  //   // var final_data = jsonDecode(response.body);
  //
  //   // print('final data $final_data');
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     _postModelList = PostModelList.fromJson(data);
  //     print(_postModelList);
  //     if (_postModelList!.error == false) {
  //       CommonWidget().showToaster(msg: 'Posted Succesfully');
  //       setState(() {
  //         ispostLoading = false;
  //       });
  //       // hideLoader(context);
  //       // Get.to(Dashboard());
  //     } else {
  //       print('Please try again');
  //     }
  //   } else {
  //     print('Please try again');
  //   }
  // }

  Future<dynamic> uploadImage() async {
    showLoader(context);
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    var url = (URLConstants.base_url + URLConstants.postApi);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    List<int> imageBytes = widget.ImageFile.readAsBytesSync();
    String baseimage = base64Encode(imageBytes);

    var files = await http.MultipartFile('postImage',
        File(widget.ImageFile.path).readAsBytes().asStream(), File(widget.ImageFile.path).lengthSync(),
        filename: widget.ImageFile.path.split("/").last);
    request.files.add(files);
    request.fields['userId'] = id_user;
    request.fields['description'] = description_controller.text;
    request.fields['trending'] = '#image';
    request.fields['uploadVideo'] = '';
    request.fields['isVideo'] = 'false';
    request.fields['tagLine'] = '';
    request.fields['address'] = '';

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      print("SUCCESS");
      print(response.reasonPhrase);
      print(widget.ImageFile.path);
      print(responseData);
      hideLoader(context);
      await Get.to(Dashboard(page: 3));
    } else {
      print("ERROR");
    }
  }
}
