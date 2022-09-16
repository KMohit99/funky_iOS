import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:helpers/helpers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../domain/providers/notifiers/control_provider.dart';
import '../../domain/providers/notifiers/draggable_widget_notifier.dart';
import '../../domain/providers/notifiers/painting_notifier.dart';
import '../../domain/providers/notifiers/scroll_notifier.dart';
import '../../domain/sevices/save_as_image.dart';
import '../utils/constants/item_type.dart';
import '../utils/constants/text_animation_type.dart';
import '../widgets/animated_onTap_button.dart';

// import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
// import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
// import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
// import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
// import 'package:stories_editor/src/domain/sevices/save_as_image.dart';
// import 'package:stories_editor/src/presentation/utils/constants/item_type.dart';
// import 'package:stories_editor/src/presentation/utils/constants/text_animation_type.dart';
// import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';

class BottomTools extends StatelessWidget {
  final GlobalKey contentKey;
  final Function(String imageUri) onDone;
  final Widget? onDoneButtonStyle;
  final Function renderWidget;

  /// editor background color
  final Color? editorBackgroundColor;

  const BottomTools(
      {Key? key,
      required this.contentKey,
      required this.onDone,
      required this.renderWidget,
      this.onDoneButtonStyle,
      this.editorBackgroundColor,})
      : super(key: key);

  final String path =
      'result/var/mobile/Containers/Data/Application/FD6B5AEF-9859-4D27-A02F-898C688C0053/Documents/stories_creator2022-07-13 12:19:40.641568.png';

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    bool _createVideo = false;
    return Consumer4<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier,
        PaintingNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier,
          paintingNotifier, __) {
        return Container(
          height: 95,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// preview gallery
              Container(
                width: _size.width / 5,
                height: _size.width / 3,
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: _preViewContainer(
                    /// if [model.imagePath] is null/empty return preview image
                    child: controlNotifier.mediaPath.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: GestureDetector(
                              onTap: () {
                                /// scroll to gridView page
                                if (controlNotifier.mediaPath.isEmpty) {
                                  scrollNotifier.pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                  // controlNotifier.mediaPath = path;
                                }
                              },
                              child: const CoverThumbnail(
                                thumbnailQuality: 10,
                              ),
                            ))

                        /// return clear [imagePath] provider
                        : GestureDetector(
                            onTap: () {
                              /// clear image url variable
                              controlNotifier.mediaPath = '';
                              itemNotifier.draggableWidget.removeAt(0);
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              color: Colors.transparent,
                              child: Transform.scale(
                                scale: 0.7,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              // Container(
              //   height: _size.width / 5,
              //   child: ListView.builder(
              //     padding: EdgeInsets.zero,
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     itemCount: imageData!.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return GestureDetector(
              //         child: Container(
              //           margin: EdgeInsets.all(5),
              //           width: 50,
              //           color: Colors.pink,
              //           child: Image.file(File(imageData![index].path),fit: BoxFit.cover,),
              //         ),
              //       );
              //     },
              //   ),
              // ),


              /// save final image to gallery
              Container(
                width: _size.width / 3,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 15),
                child: Transform.scale(
                  scale: 0.9,
                  child: StatefulBuilder(
                    builder: (_, setState) {
                      return AnimatedOnTapButton(
                          onTap: () async {
                            String pngUri;
                            if (paintingNotifier.lines.isNotEmpty ||
                                itemNotifier.draggableWidget.isNotEmpty) {
                              for (var element
                                  in itemNotifier.draggableWidget) {
                                if (element.type == ItemType.video ||
                                    element.animationType !=
                                        TextAnimationType.none) {
                                  setState(() {
                                    _createVideo = true;
                                  });
                                }
                              }
                              if (_createVideo) {
                                debugPrint('creating video');
                                await renderWidget();
                              } else {
                                debugPrint('creating image');
                                await takePicture(
                                        contentKey: contentKey,
                                        context: context,
                                        saveToGallery: false)
                                    .then((bytes) {
                                  if (bytes != null) {
                                    pngUri = bytes;
                                    onDone(pngUri);
                                  } else {}
                                });
                                // debugPrint('creating image');
                                // var response = await takePicture(
                                //     contentKey: contentKey,
                                //     context: context,
                                //     saveToGallery: true);
                                // if (response) {
                                //   Fluttertoast.showToast(
                                //       msg: 'Successfully saved');
                                // } else {
                                //   Fluttertoast.showToast(msg: 'Error');
                                // }
                              }
                            }
                            setState(() {
                              _createVideo = false;
                            });
                          },
                          child: onDoneButtonStyle ??
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 5, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: HexColor('#C12265'),
                                    border: Border.all(
                                        color: Colors.white, width: 1.5)),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text(
                                        'Share',
                                        style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ]),
                              ));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.4, color: Colors.white)),
      child: child,
    );
  }
}
