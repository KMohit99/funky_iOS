import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/profile_screen/profile_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../Utils/custom_textfeild.dart';
import '../../Utils/toaster_widget.dart';
import '../../custom_widget/common_buttons.dart';
import '../../sharePreference.dart';
import '../dashboard_screen.dart';

class Story_image_preview extends StatefulWidget {
  final bool isImage;
  final File ImageFile;

  const Story_image_preview(
      {Key? key, required this.ImageFile, required this.isImage})
      : super(key: key);

  @override
  State<Story_image_preview> createState() => _Story_image_previewState();
}

class _Story_image_previewState extends State<Story_image_preview> {
  bool valuefirst = false;
  TextEditingController title_controller = new TextEditingController();
  bool isClicked = false; // boolean that states if the button is pressed or not
  VideoPlayerController? video_controller;

  @override
  void initState() {
    super.initState();
    print('image urlllllllllllll ${widget.ImageFile}');
    video_controller = VideoPlayerController.file(widget.ImageFile);

    video_controller!.setLooping(true);
    video_controller!.initialize().then((_) {
      setState(() {});
    });
    video_controller!.pause();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    video_controller!.dispose();
  }

  share_icon() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Share your story", style: TextStyle(
            fontSize: 18, color: Colors.black, fontFamily: 'PM')),
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
              'Post Story',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (widget.isImage
                      ? Container(
                          child: Image.file(
                            widget.ImageFile,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            print('hello');
                            isClicked = isClicked ? false : true;
                            print(isClicked);
                            if (video_controller!.value.isPlaying) {
                              video_controller!.pause();
                            } else {
                              video_controller!.play();
                            }
                          },
                          child: Container(
                            // color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.2,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: AspectRatio(
                                  aspectRatio:
                                      video_controller!.value.aspectRatio,
                                  child: VideoPlayer(video_controller!)),
                            ),
                          ),
                        )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> uploadImage() async {
    showLoader(context);
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    var url = (URLConstants.base_url + URLConstants.StoryPostApi);
    var request = http.MultipartRequest('POST', Uri.parse(url));

    print("IIIiiiiIIIIII ${widget.ImageFile.path}");
    var files = (widget.isImage
        ? await http.MultipartFile.fromPath(
            'story_photo[]', widget.ImageFile.path)
        : await http.MultipartFile.fromPath(
            'story_photo[]', widget.ImageFile.path));
    request.files.add(files);
    request.fields['userId'] = id_user;
    request.fields['title'] = title_controller.text;
    // request.fields['uploadVideo'] = '';
    request.fields['isVideo'] = (widget.isImage ? 'false' : 'true');

    // request.fields['isVideo'] = '';

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    print("response.statusCode");
    print(response.statusCode);

    if (response.statusCode == 200) {
      print("SUCCESS");
      print(response.reasonPhrase);
      print(widget.ImageFile.path);
      print(responseData);
      hideLoader(context);
      await Get.to(Dashboard(
        page: 3,
      ));
    } else {
      print("ERROR");
    }
  }
}
