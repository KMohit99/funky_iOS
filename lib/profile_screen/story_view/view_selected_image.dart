import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

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
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(Story_image_preview(
                    ImageFile: widget.imageData,
                    // isImage: true,
                  ));
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
                      child: Image.file(
                        File(widget.imageData[index].path),
                        fit: BoxFit.cover,
                      ),
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
