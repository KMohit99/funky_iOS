import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/toaster_widget.dart';
import '../../custom_widget/page_loader.dart';
import '../constants/app_constants.dart';

class FullVideoPage extends StatefulWidget {
  final String url;

  const FullVideoPage({Key? key, required this.url}) : super(key: key);

  @override
  State<FullVideoPage> createState() => _FullVideoPageState();
}

class _FullVideoPageState extends State<FullVideoPage> {
  VideoPlayerController? _controller;

  bool _onTouch = false;
  Timer? _timer;
  bool isClicked = false; // boolean that states if the button is pressed or not

  @override
  void initState() {
    super.initState();
    print('image urlllllllllllll ${widget.url}');
    _controller = VideoPlayerController.network(
        "${widget.url}");

    _controller!.setLooping(true);
    _controller!.initialize().then((_) {
      setState(() {});
    });
    _controller!.play();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    _controller!.dispose();
  }

  int _currentPage = 0;

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
                HexColor("#330417"),
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
                'Full Video',
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
            body: SingleChildScrollView(
              child: InkWell(
                onTap: () {},
                child: _controller!.value.isInitialized
                    ? Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('hello');
                        isClicked = isClicked ? false : true;
                        print(isClicked);
                      },
                      child: Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: Center(
                          child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!)),
                        ),
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.red,
                    //     gradient: LinearGradient(
                    //       begin: Alignment.topCenter,
                    //       end: Alignment.bottomCenter,
                    //       // stops: [0.1, 0.5, 0.7, 0.9],
                    //       colors: [
                    //         HexColor("#000000"),
                    //         HexColor("#000000").withOpacity(0.7),
                    //         HexColor("#000000").withOpacity(0.3),
                    //         Colors.transparent
                    //       ],
                    //     ),
                    //   ),
                    //   alignment: Alignment.topCenter,
                    //   height: MediaQuery.of(context).size.height/5,
                    // ),
                  ],
                )
                    : Container(),
              ),
            )),
      ],
    );
  }

  Future _asyncMethod() async {

    showLoader(context);
    String url = widget.url;
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/myfile.mp4';
    await Dio().download(url,path);

    await GallerySaver.saveVideo(path);
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
}
