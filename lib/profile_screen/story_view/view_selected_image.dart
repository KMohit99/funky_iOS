import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../Utils/asset_utils.dart';
import '../../dashboard/story_/stories_editor.dart';
import '../../dashboard/story_/story_image_preview.dart';

class ViewImageSelected extends StatefulWidget {
  final List<XFile> imageData;

  const ViewImageSelected({Key? key, required this.imageData})
      : super(key: key);

  @override
  State<ViewImageSelected> createState() => _ViewImageSelectedState();
}

class _ViewImageSelectedState extends State<ViewImageSelected> {
  List<String> format = [];
  List<File> thumb_list = [];

  init() async {
    for (var i = 0; i < widget.imageData.length; i++) {
      var file_format = widget.imageData[i].path
          .substring(widget.imageData[i].path.lastIndexOf('.'));
      print(file_format);

      format.add(file_format);
      print(format);
      // final uint8list = await VideoThumbnail.thumbnailData(
      //   video: widget.imageData[i].path,
      //   // thumbnailPath: (await getTemporaryDirectory()).path,
      //   imageFormat: ImageFormat.JPEG,
      //   maxHeight: 64,
      //   // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      //   quality: 75,
      // );
      // thumb_list.add(File.fromRawPath(uint8list!));
      // print(test_thumb[i].path);

      // print("test----------${thumb_list[i].path}");
    }
  }

  @override
  void initState() {
    init();
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
                HexColor("#000000"),
                HexColor("#000000"),
                HexColor("#C12265"),
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
            actions: [
              GestureDetector(
                onTap: () {
                  // Get.to(Story_image_preview(
                  //   ImageFile: widget.imageData,
                  //   // isImage: true,
                  // ));
                  (widget.imageData.length > 1
                      ? Get.to(Story_image_preview(
                          ImageFile: widget.imageData,
                          single: false,
                          // isImage: true,
                        ))
                      : Get.to(Story_image_preview(
                          single_image: File(widget.imageData[0].path),
                          single: true,
                          // isImage: true,
                        )));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PM',
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: GridView.builder(
            itemCount: widget.imageData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: (format[index] == '.jpg'
                          ? Image.file(
                              File(widget.imageData[index].path),
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Image.asset(
                              AssetUtils.logo_trans,
                              height: 50,
                              width: 50,
                            ))),
                    ),
                    Positioned(
                        top: 5,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            print(widget.imageData[index].path);
                            File editedFile = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => StoriesEditor(
                                          // fontFamilyList: font_family,
                                          giphyKey:
                                              'https://giphy.com/gifs/congratulations-congrats-xT0xezQGU5xCDJuCPe',
                                          imageData: File(
                                              widget.imageData[index].path),
                                          onDone: (String) {},
                                          // filePath:
                                          //     imgFile!.path,
                                        )));
                            if (editedFile != null) {
                              print('editedFile: ${editedFile.path}');
                              setState(() {
                                widget.imageData[index] =
                                    XFile(editedFile.path);
                              });
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    // stops: [0.1, 0.5, 0.7, 0.9],
                                    colors: [
                                      HexColor("#000000"),
                                      HexColor("#C12265"),
                                      HexColor("#C12265"),
                                    ],
                                  ),
                                  border: Border.all(
                                      color: Colors.white, width: 1)),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              )),
                        )),
                  ],
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 4 / 5),
          ),
        ),
      ],
    );
  }
}
