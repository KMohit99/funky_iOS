import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:funky_new/Utils/App_utils.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/toaster_widget.dart';
import '../../custom_widget/common_buttons.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../sharePreference.dart';
import '../model/storyeditmodel.dart';
import 'package:http/http.dart' as http;

class StoryEdit extends StatefulWidget {
  final String ImageFile;
  final String storyId;
  final String story_title;
  final String isvideo;

  const StoryEdit(
      {Key? key,
      required this.ImageFile,
      required this.storyId,
      required this.story_title,
      required this.isvideo})
      : super(key: key);

  @override
  State<StoryEdit> createState() => _StoryEditState();
}

class _StoryEditState extends State<StoryEdit> {
  bool valuefirst = false;
  TextEditingController title_controller = new TextEditingController();
  bool isClicked = false; // boolean that states if the button is pressed or not
  VideoPlayerController? video_controller;

  share_icon() {
    return showDialog(
      context: context,
      // AlertDialog(
      //   backgroundColor: Colors.transparent,
      //   contentPadding: EdgeInsets.zero,
      //   elevation: 0.0,
      //   content: Container(
      //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      //     height: MediaQuery.of(context).size.height / 5,
      //     // width: 133,
      //     // padding: const EdgeInsets.all(8.0),
      //     decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: const Alignment(-1.0, 0.0),
      //           end: const Alignment(1.0, 0.0),
      //           transform: const GradientRotation(0.7853982),
      //           // stops: [0.1, 0.5, 0.7, 0.9],
      //           colors: [
      //             HexColor("#000000"),
      //             HexColor("#000000"),
      //             HexColor("##E84F90"),
      //             HexColor("#ffffff"),
      //             // HexColor("#FFFFFF").withOpacity(0.67),
      //           ],
      //         ),
      //         color: Colors.white,
      //         border: Border.all(color: Colors.white, width: 1),
      //         borderRadius: const BorderRadius.all(Radius.circular(26.0))),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Row(
      //           mainAxisSize: MainAxisSize.min,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Container(
      //               margin: const EdgeInsets.symmetric(vertical: 10),
      //               child: Row(
      //                 // mainAxisAlignment:
      //                 // MainAxisAlignment
      //                 //     .center,
      //                 children: [
      //                   Column(
      //                     children: [
      //                       IconButton(
      //                         icon: const Icon(
      //                           Icons.delete_forever_outlined,
      //                           size: 30,
      //                           color: Colors.white,
      //                         ),
      //                         onPressed: () {
      //                           delete_story(story_id: story_id);
      //                           // camera_upload();
      //                         },
      //                       ),
      //                       SizedBox(
      //                         height: 5,
      //                       ),
      //                       GestureDetector(
      //                         onTap: () {
      //                           delete_story(story_id: story_id);
      //                         },
      //                         child: Container(
      //                           margin:
      //                           const EdgeInsets.symmetric(horizontal: 0),
      //                           // height: 45,
      //                           // width:(width ?? 300) ,
      //                           width: 100,
      //                           decoration: BoxDecoration(
      //                               border: Border.all(
      //                                   color: Colors.white, width: 1),
      //                               borderRadius: BorderRadius.circular(25)),
      //                           child: Container(
      //                               alignment: Alignment.center,
      //                               margin: EdgeInsets.symmetric(
      //                                   vertical: 12, horizontal: 20),
      //                               child: Text(
      //                                 'Delete',
      //                                 style: TextStyle(
      //                                     color: Colors.white,
      //                                     fontFamily: 'PR',
      //                                     fontSize: 16),
      //                               )),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(
      //                     width: 20,
      //                   ),
      //                   Column(
      //                     children: [
      //                       IconButton(
      //                         icon: const Icon(
      //                           Icons.auto_fix_high_rounded,
      //                           size: 30,
      //                           color: Colors.white,
      //                         ),
      //                         onPressed: () async {
      //                           Get.to(StoryEdit(
      //                             ImageFile: story_image,
      //                             storyId: story_id,
      //                             story_title: story_title,
      //                             isvideo:  is_video,
      //                           ));
      //                           // File editedFile = await Navigator.of(context)
      //                           //     .push(MaterialPageRoute(
      //                           //         builder: (context) => StoriesEditor(
      //                           //               // fontFamilyList: font_family,
      //                           //               giphyKey: '',
      //                           //               onDone: (String) {},
      //                           //               // filePath:
      //                           //               //     imgFile!.path,
      //                           //             )));
      //                           // if (editedFile != null) {
      //                           //   print('editedFile: ${editedFile.path}');
      //                           // }
      //                         },
      //                       ),
      //                       SizedBox(
      //                         height: 5,
      //                       ),
      //                       Container(
      //                         margin: const EdgeInsets.symmetric(horizontal: 0),
      //                         // height: 45,
      //                         width: 100,
      //                         decoration: BoxDecoration(
      //                             border:
      //                             Border.all(color: Colors.white, width: 1),
      //                             borderRadius: BorderRadius.circular(25)),
      //                         child: Container(
      //                             alignment: Alignment.center,
      //                             margin: EdgeInsets.symmetric(
      //                                 vertical: 12, horizontal: 20),
      //                             child: Text(
      //                               'Edit',
      //                               style: TextStyle(
      //                                   color: Colors.white,
      //                                   fontFamily: 'PR',
      //                                   fontSize: 16),
      //                             )),
      //                       ),
      //                     ],
      //                   ),
      //
      //                   // IconButton(
      //                   //   icon: const Icon(
      //                   //     Icons
      //                   //         .video_call,
      //                   //     size: 40,
      //                   //     color: Colors
      //                   //         .grey,
      //                   //   ),
      //                   //   onPressed:
      //                   //       () {
      //                   //         video_upload();
      //                   //       },
      //                   // ),
      //                 ],
      //               ),
      //             )
      //
      //             // const SizedBox(
      //             //   height: 10,
      //             // ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      builder: (ctx) => AlertDialog(
        title: Text("Update your story",
            style:
                TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'PM')),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: common_button(
              onTap: () {
                // uploadImage();
                update_story_list(context);
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
  void initState() {
    title_controller.text = widget.story_title;
    super.initState();
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
            title: const Text(
              'Edit Story',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'PB'),
            ),
            centerTitle: true,
            leadingWidth: 100,
            leading: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  print('oject');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Dashboard(page: 3)));
                  // Navigator.pop(context);
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
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: (widget.isvideo == 'true'
                          ? Image.asset('assets/images/Funky_App_Icon.png')
                          : FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              image:
                                  "${URLConstants.base_data_url}images/${widget.ImageFile}",
                              placeholder: 'assets/images/Funky_App_Icon.png',
                              // color: HexColor(CommonColor.pinkFont),
                            )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // width: 300,
                    child: TextFormField(
                      maxLength: 20,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 20, top: 14, bottom: 14),
                        alignLabelWithHint: false,
                        isDense: true,
                        labelText: 'Title',
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
                      controller: title_controller,
                      // keyboardType: keyboardType ?? TextInputType.multiline,
                    ),
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
  }

  StoryEditModel? _videoModelList;
  Future<dynamic> update_story_list(BuildContext context) async {

    showLoader(context);
    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'stID': widget.storyId,
      'title': title_controller.text,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.StoryEditApi);
    print("url : $url");
    print("body : $data");
    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);
    // print('final data $final_data');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _videoModelList = StoryEditModel.fromJson(data);

      if (_videoModelList!.error == false) {

        CommonWidget().showToaster(msg: _videoModelList!.message!);
        hideLoader(context);
        Get.to(Dashboard(page: 3));

      } else {
        hideLoader(context);
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

}
