import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:funky_new/dashboard/story_/story_image_preview.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

Future takePicture(
    {required contentKey,
    required BuildContext context,
    required saveToGallery}) async {
  try {
    /// converter widget to image
    RenderRepaintBoundary boundary =
        contentKey.currentContext.findRenderObject();

    ui.Image image = await boundary.toImage(pixelRatio: 3);
    ///

    ///

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    /// create file
    final String dir = (await getApplicationDocumentsDirectory()).path;
    String imagePath = '$dir/stories_creator${DateTime.now()}.png';
    File capturedFile = File(imagePath);
    await capturedFile.writeAsBytes(pngBytes);
    print(capturedFile.path);
    Navigator.pop(context, capturedFile);

    // await Get.to(Story_image_preview(ImageFile: capturedFile, isImage: true,));

    // if (saveToGallery) {
    //   final result = await ImageGallerySaver.saveImage(pngBytes,
    //       quality: 100, name: "stories_creator${DateTime.now()}.png");
    //   print("result${imagePath}");
    //   await Get.to(Story_image_preview(ImageFile: File(imagePath), isImage: true,));
    //   if (result != null) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } else {
    //   return imagePath;
    // }
  } catch (e) {
    debugPrint('exception => $e');
    return false;
  }
}
