import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/Utils/toaster_widget.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:gallery_saver/gallery_saver.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import '../constants/app_constants.dart';
import '../constants/color_constants.dart';

class FullPhotoPage extends StatefulWidget {
  final String url;

  FullPhotoPage({Key? key, required this.url}) : super(key: key);

  @override
  State<FullPhotoPage> createState() => _FullPhotoPageState();
}

class _FullPhotoPageState extends State<FullPhotoPage> {
  @override
  initState() {
    print(widget.url);
    // _asyncMethod();
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
                HexColor("##330417"),
                HexColor("#000000"),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              AppConstants.fullPhotoTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PR',
                  fontSize: 16),
            ),
            centerTitle: true,
            actions: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: IconButton(
                  onPressed: (){
                    _asyncMethod();
                    // _download();
                  },
                  icon: Icon(Icons.download,color: Colors.white,),
                ),
              )
            ],
          ),
          body: Container(
            margin: EdgeInsets.only(top: 100,right: 30,left: 30),
            child: PhotoView(
              imageProvider: NetworkImage(widget.url),
            ),
          ),
        ),
      ],
    );
  }

  Future _asyncMethod() async {

    showLoader(context);
    String url = widget.url;
     final tempDir = await getTemporaryDirectory();
     final path = '${tempDir.path}/myfile.jpg';
     await Dio().download(url,path);

     await GallerySaver.saveImage(path);
     hideLoader(context);
     CommonWidget().showToaster(msg: 'Image Saved');




    // //comment out the next two lines to prevent the device from getting
    // // the image from the web in order to prove that the picture is
    // // coming from the device instead of the web.
    // var url = "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; // <-- 1
    // var response = await get(Uri.parse(widget.url)); // <--2
    // var documentDirectory = await getApplicationDocumentsDirectory();
    // var firstPath = documentDirectory.path + "/images";
    // var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    // //comment out the next three lines to prevent the image from being saved
    // //to the device to show that it's coming from the internet
    // await Directory(firstPath).create(recursive: true); // <-- 1
    // File file2 = File(filePathAndName);             // <-- 2
    // file2.writeAsBytesSync(response.bodyBytes);         // <-- 3
    // print(filePathAndName);
    // setState((){
    //
    // });
  }
    Future<void> _download() async {
      final response = await http.get(Uri.parse(widget.url));

      // Get the image name
      final imageName = path.basename(widget.url);
      // Get the document directory path
      final appDir = await path_provider.getApplicationDocumentsDirectory();

      // This is the saved image path
      // You can use it to display the saved image later
      final localPath = path.join(appDir.path, imageName);

      // Downloading
      final imageFile = File(localPath);
      await imageFile.writeAsBytes(response.bodyBytes);

      setState(() {
        print(imageFile.path);
        // _displayImage = imageFile;
      });
    }


}
