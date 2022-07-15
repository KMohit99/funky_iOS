import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camerawesome/models/orientations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/Utils/asset_utils.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/video_recorder/lib/widgets/bottom_bar.dart';
import 'package:funky_new/video_recorder/lib/widgets/camera_preview.dart';
import 'package:funky_new/video_recorder/lib/widgets/preview_card.dart';
import 'package:funky_new/video_recorder/lib/widgets/top_bar.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image/image.dart' as imgUtils;
import 'package:image_editor_plus/image_editor_plus.dart';

import 'package:path_provider/path_provider.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:video_compress/video_compress.dart';
// import 'package:video_compress/video_compress.dart';

import '../../Utils/colorUtils.dart';
import '../../Utils/toaster_widget.dart';
import '../../dashboard/post_image_preview.dart';
import '../../dashboard/post_video_preview.dart';
import '../../dashboard/story_/stories_editor.dart';
import '../../dashboard/story_/story_image_preview.dart';
import '../../dashboard/video_editor.dart';
import 'dart:io' as Io;

class MyApp_video extends StatefulWidget {
  // just for E2E test. if true we create our images names from datetime.
  // Else it's just a name to assert image exists
  final bool randomPhotoName;
  final bool? story;

  MyApp_video({this.randomPhotoName = true, this.story});

  @override
  _MyApp_videoState createState() => _MyApp_videoState();
}

class _MyApp_videoState extends State<MyApp_video>
    with TickerProviderStateMixin {
  String _lastPhotoPath = 'path';
  String _lastVideoPath = 'path';
  bool _focus = false, _fullscreen = true, _isRecordingVideo = false;

  ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<double> _zoomNotifier = ValueNotifier(0);
  ValueNotifier<Size> _photoSize = ValueNotifier(Size.zero);
  ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<bool> _enableAudio = ValueNotifier(true);
  ValueNotifier<CameraOrientations> _orientation =
      ValueNotifier(CameraOrientations.PORTRAIT_UP);

  /// use this to call a take picture
  PictureController _pictureController = PictureController();

  /// use this to record a video
  VideoController _videoController = VideoController();

  /// list of available sizes
  List<Size>? _availableSizes;

  AnimationController? _iconsAnimationController, _previewAnimationController;
  late Animation<Offset> _previewAnimation;
  Timer? _previewDismissTimer;

  // StreamSubscription<Uint8List> previewStreamSub;
  Stream<Uint8List>? previewStream;

  @override
  void initState() {
    super.initState();
    _iconsAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _previewAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );
    _previewAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _previewAnimationController!,
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _iconsAnimationController!.dispose();
    _previewAnimationController!.dispose();
    // previewStreamSub.cancel();
    _photoSize.dispose();
    _captureMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: Text('data'),
          ),
          this._fullscreen ? buildFullscreenCamera() : buildSizedScreenCamera(),
          _buildInterface(),
          (!_isRecordingVideo)
              ? PreviewCardWidget(
                  lastPhotoPath: _lastPhotoPath,
                  orientation: _orientation,
                  previewAnimation: _previewAnimation,
                )
              : (instopvideo
                  ? Center(
                      child: Container(
                          height: 80,
                          width: 100,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircularProgressIndicator(
                                color: HexColor(CommonColor.pinkFont),
                              ),
                            ],
                          )
                          // Material(
                          //   color: Colors.transparent,
                          //   child: LoadingIndicator(
                          //     backgroundColor: Colors.transparent,
                          //     indicatorType: Indicator.ballScale,
                          //     colors: _kDefaultRainbowColors,
                          //     strokeWidth: 4.0,
                          //     pathBackgroundColor: Colors.yellow,
                          //     // showPathBackground ? Colors.black45 : null,
                          //   ),
                          // ),
                          ),
                    )
                  : Container()),
        ],
      ),
    );
  }

  final List<int> data = <int>[
    15,
    60,
  ];
  bool seconds_15 = true;
  bool seconds_60 = false;
  int seconds_selected = 15;

  Widget _buildInterface() {
    final seconds15 = myDuration15.inSeconds.remainder(60);
    final seconds60 = myDuration60.inSeconds.remainder(60);

    return Stack(
      children: <Widget>[
        // Container(
        //   margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        //   height: 50,
        //   color: Colors.black38,
        //   width: MediaQuery.of(context).size.width,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: FormField<int>(
        //       builder: (FormFieldState<int> state) {
        //         return DropdownButtonHideUnderline(
        //           child: DropdownButton2(
        //             isExpanded: true,
        //             hint: Row(
        //               children: [
        //                 SizedBox(
        //                   width: 4,
        //                 ),
        //                 Expanded(
        //                   child: Text(
        //                     'Tax Type',
        //                     style: TextStyle(fontSize: 12, color: Colors.red),
        //                     overflow: TextOverflow.ellipsis,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             items: data
        //                 .map((item) => DropdownMenuItem<int>(
        //                       value: item,
        //                       child: Text(
        //                         "$item Seconds",
        //                         style: TextStyle(
        //                           fontSize: 14,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.black,
        //                         ),
        //                         overflow: TextOverflow.ellipsis,
        //                       ),
        //                     ))
        //                 .toList(),
        //             value: selectedValue,
        //             onChanged: (value) {
        //               setState(() {
        //                 selectedValue = value as int;
        //               });
        //               print(selectedValue);
        //             },
        //             iconSize: 25,
        //             // icon: SvgPicture.asset(AssetUtils.drop_svg),
        //             iconEnabledColor: Color(0xff007DEF),
        //             iconDisabledColor: Color(0xff007DEF),
        //             buttonHeight: 50,
        //             buttonWidth: 160,
        //             buttonPadding: const EdgeInsets.only(left: 15, right: 15),
        //             buttonDecoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color: Colors.white30,
        //             ),
        //             buttonElevation: 0,
        //             itemHeight: 40,
        //             itemPadding: const EdgeInsets.only(left: 14, right: 14),
        //             dropdownMaxHeight: 200,
        //             dropdownPadding: null,
        //             dropdownDecoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color: Colors.white,
        //             ),
        //             dropdownElevation: 8,
        //             scrollbarRadius: const Radius.circular(40),
        //             scrollbarThickness: 6,
        //             scrollbarAlwaysShow: true,
        //             offset: const Offset(0, -10),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
        SafeArea(
          bottom: false,
          child: TopBarWidget(
              isFullscreen: _fullscreen,
              isRecording: _isRecordingVideo,
              enableAudio: _enableAudio,
              photoSize: _photoSize,
              captureMode: _captureMode,
              switchFlash: _switchFlash,
              orientation: _orientation,
              rotationController: _iconsAnimationController!,
              onFlashTap: () {
                switch (_switchFlash.value) {
                  case CameraFlashes.NONE:
                    _switchFlash.value = CameraFlashes.ON;
                    break;
                  case CameraFlashes.ON:
                    _switchFlash.value = CameraFlashes.AUTO;
                    break;
                  case CameraFlashes.AUTO:
                    _switchFlash.value = CameraFlashes.ALWAYS;
                    break;
                  case CameraFlashes.ALWAYS:
                    _switchFlash.value = CameraFlashes.NONE;
                    break;
                }
                setState(() {});
              },
              onAudioChange: () {
                this._enableAudio.value = !this._enableAudio.value;
                setState(() {});
              },
              onChangeSensorTap: () {
                this._focus = !_focus;
                if (_sensor.value == Sensors.FRONT) {
                  _sensor.value = Sensors.BACK;
                } else {
                  _sensor.value = Sensors.FRONT;
                }
              },
              onResolutionTap: () => _buildChangeResolutionDialog(),
              onFullscreenTap: () {
                this._fullscreen = !this._fullscreen;
                setState(() {});
              }),
        ),
        Positioned(
          bottom: 200,
          left: 20,
          child: Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      seconds_15 = true;
                      seconds_60 = false;
                      seconds_selected = 15;
                    });
                    debugPrint(seconds_selected.toString());
                  },
                  child: Image.asset(
                    (seconds_15
                        ? AssetUtils.seconds_15_selected
                        : AssetUtils.seconds_15_unselected),
                    scale: 2,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      seconds_15 = false;
                      seconds_60 = true;
                      seconds_selected = 59;
                    });
                    print(seconds_60);
                    debugPrint(seconds_selected.toString());
                  },
                  child: Image.asset(
                    (seconds_60
                        ? AssetUtils.seconds_60_selected
                        : AssetUtils.seconds_60_unselected),
                    scale: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 170,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              (seconds_15
                  ? "00:$seconds15"
                  : (seconds_60 ? "00:$seconds60" : "00:$seconds15")),
              style: TextStyle(
                  fontSize: 16, fontFamily: 'PB', color: Colors.white),
            ),
          ),
        ),
        BottomBarWidget(
          onZoomInTap: () {
            if (_zoomNotifier.value <= 0.9) {
              _zoomNotifier.value += 0.1;
            }
            setState(() {});
          },
          onZoomOutTap: () {
            if (_zoomNotifier.value >= 0.1) {
              _zoomNotifier.value -= 0.1;
            }
            setState(() {});
          },
          onCaptureModeSwitchChange: () {
            if (_captureMode.value == CaptureModes.PHOTO) {
              _captureMode.value = CaptureModes.VIDEO;
            } else {
              _captureMode.value = CaptureModes.PHOTO;
            }
            setState(() {});
          },
          onCaptureTap: (_captureMode.value == CaptureModes.PHOTO)
              ? _takePhoto
              : (_isRecordingVideo ? _stopvideo : _recordVideo),
          rotationController: _iconsAnimationController!,
          orientation: _orientation,
          isRecording: _isRecordingVideo,
          captureMode: _captureMode,
          onChangeSensorTap: () {
            this._focus = !_focus;
            if (_sensor.value == Sensors.FRONT) {
              _sensor.value = Sensors.BACK;
            } else {
              _sensor.value = Sensors.FRONT;
            }
          },
          switchFlash: _switchFlash,
          onFlashTap: () {
            switch (_switchFlash.value) {
              case CameraFlashes.NONE:
                _switchFlash.value = CameraFlashes.ON;
                break;
              case CameraFlashes.ON:
                _switchFlash.value = CameraFlashes.AUTO;
                break;
              case CameraFlashes.AUTO:
                _switchFlash.value = CameraFlashes.ALWAYS;
                break;
              case CameraFlashes.ALWAYS:
                _switchFlash.value = CameraFlashes.NONE;
                break;
            }
            setState(() {});
          },
        ),
      ],
    );
  }

  Uint8List? imageData;
  File? imgFile;

  _takePhoto() async {
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/test').create(recursive: true);
    final String filePath = widget.randomPhotoName
        ? '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg'
        : '${testDir.path}/photo_test.jpg';
    await _pictureController.takePicture(filePath);
    // lets just make our phone vibrate
    HapticFeedback.mediumImpact();
    _lastPhotoPath = filePath;
    setState(() {});
    if (_previewAnimationController!.status == AnimationStatus.completed) {
      _previewAnimationController!.reset();
    }
    _previewAnimationController!.forward();

    imgFile = File(filePath);
    imageData = imgFile!.readAsBytesSync();

    if (widget.story == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: imageData,
          ),
        ),
      ).then((editedImage) {
        if (editedImage != null) {
          setState(() {
            // imgFile = editedImage;
            String base64String = base64Encode(editedImage);
            final decodedBytes = base64Decode(base64String);
            var file = Io.File(imgFile!.path);
            file.writeAsBytesSync(decodedBytes);
            print(file.path.split('/').last);
            imgFile = file;
            Get.to(PostImagePreviewScreen(
              ImageFile: editedImage!,
            ));
            Navigator.pop(context);
          });
        }
      }).catchError((er) {
        print(er);
      });
    } else {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => StoriesEditor(
      //               // fontFamilyList: font_family,
      //               giphyKey: '',
      //               imageData: File(filePath),
      //               onDone: (String) {},
      //               // filePath:
      //               //     imgFile!.path,
      //             )));
    }
    ;
    print("----------------------------------");
    print("TAKE PHOTO CALLED");
    final file = File(filePath);
    print("==> hastakePhoto : ${file.exists()} | path : $filePath");
    final img = imgUtils.decodeImage(file.readAsBytesSync());
    print("==> img.width : ${img!.width} | img.height : ${img.height}");
    print("----------------------------------");
  }

  Timer? countdownTimer_15;
  Timer? countdownTimer_60;
  Duration myDuration15 = const Duration(seconds: 15);
  Duration myDuration60 = const Duration(seconds: 59);

  void startTimer_15() {
    countdownTimer_15 =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown_15());
  }

  void startTimer_60() {
    countdownTimer_60 =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown_60());
  }

  void setCountDown_15() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds15 = myDuration15.inSeconds - reduceSecondsBy;
      if (seconds15 < 0) {
        countdownTimer_15!.cancel();
        print('timesup');
      } else {
        myDuration15 = Duration(seconds: seconds15);
      }
    });
  }

  void setCountDown_60() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds60 = myDuration60.inSeconds - reduceSecondsBy;
      if (seconds60 < 0) {
        countdownTimer_60!.cancel();
        print('timesup');
        // _stopvideo();
      } else {
        myDuration60 = Duration(seconds: seconds60);
      }
    });
  }

  startWatch() {
    setState(() {
      watch.start();
      // startTimer();
      timer = Timer.periodic(Duration(microseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      watch.stop();
      _stopvideo();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
    print("elapsedTime $elapsedTime");
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  Stopwatch watch = Stopwatch();
  Timer? timer;
  bool startStop = true;
  bool started = true;

  String elapsedTime = '00:00';

  updateTime(Timer timer) async {
    if (watch.isRunning) {
      if (mounted) {
        setState(() {
          // print("startstop Inside=$startStop");
          elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
        });
        // if (elapsedTime == seconds_selected) {
        //   // stopWatch();
        //   // showLoader(context);
        //   // setState(() {
        //   //   _isRecordingVideo = true;
        //   // });
        //   // _recordVideo();
        //   print("15 seconds complete");
        //   print("inside stop video");
        //   await _videoController.stopRecordingVideo();
        //
        //   // setState(() {
        //   //   _isRecordingVideo = false;
        //   // });
        //   // setState(() {});
        //
        //   final file = File(_lastVideoPath);
        //   print("----------------------------------");
        //   print("VIDEO RECORDED");
        //   print(
        //       "==> has been recorded : ${file.exists()} | path : $_lastVideoPath");
        //   print("----------------------------------");
        //
        //   await Future.delayed(Duration(milliseconds: 300));
        //   MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        //     _lastVideoPath,
        //     quality: VideoQuality.MediumQuality,
        //     deleteOrigin: false, // It's false by default
        //   );
        //   print("page navigation");
        //   // await hideLoader(context);
        //   await Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => VideoEditor(
        //               file: File(mediaInfo!.path!),
        //             )
        //         //     CameraPreview(
        //         //   videoPath: _lastVideoPath,
        //         // ),
        //         ),
        //   );
        //   // start_animation();
        // }
      }
    }
  }

  bool instopvideo = false;

  _stopvideo() async {
    print("inside stop video");
    await _videoController.stopRecordingVideo();

    setState(() {
      instopvideo = true;
      _isRecordingVideo = false;
    });
    setState(() {});

    final file = File(_lastVideoPath);
    print("----------------------------------");
    print("VIDEO RECORDED");
    print("==> has been recorded : ${file.exists()} | path : $_lastVideoPath");
    print("----------------------------------");

    Fluttertoast.showToast(
      msg: "Please Wait",
      timeInSecForIosWeb: 5,
      textColor: Colors.black,
      backgroundColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      _lastVideoPath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false, // It's false by default
    );
    print("page navigation");
    setState(() {
      instopvideo = false;
    });
    (widget.story == false
        ? await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoEditor(
                      file: File(mediaInfo!.path!),
                    )
                //     CameraPreview(
                //   videoPath: _lastVideoPath,
                // ),
                ),
          )
        : await Get.to(Story_image_preview(
            ImageFile: File(mediaInfo!.path!),
            isImage: false,
          )));
  }

  _recordVideo() async {
    // lets just make our phone vibrate
    HapticFeedback.mediumImpact();

    // if (_isRecordingVideo) {
    //   // stopWatch();
    //   print("inside stop video");
    //   await _videoController.stopRecordingVideo();
    //
    //   setState(() {
    //     _isRecordingVideo = false;
    //   });
    //   setState(() {});
    //
    //   final file = File(_lastVideoPath);
    //   print("----------------------------------");
    //   print("VIDEO RECORDED");
    //   print(
    //       "==> has been recorded : ${file.exists()} | path : $_lastVideoPath");
    //   print("----------------------------------");
    //
    //   await Future.delayed(Duration(milliseconds: 300));
    //   MediaInfo? mediaInfo = await VideoCompress.compressVideo(
    //     _lastVideoPath,
    //     quality: VideoQuality.MediumQuality,
    //     deleteOrigin: false, // It's false by default
    //   );
    //   print("page navigation");
    //   await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => VideoEditor(
    //               file: File(mediaInfo!.path!),
    //             )
    //         //     CameraPreview(
    //         //   videoPath: _lastVideoPath,
    //         // ),
    //         ),
    //   );
    // } else {
    //   final Directory extDir = await getTemporaryDirectory();
    //   final testDir =
    //       await Directory('${extDir.path}/test').create(recursive: true);
    //   final String filePath = widget.randomPhotoName
    //       ? '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4'
    //       : '${testDir.path}/video_test.mp4';
    //   await _videoController.recordVideo(filePath);
    //   _isRecordingVideo = true;
    //   _lastVideoPath = filePath;
    //   setState(() {});
    //   // startTimer();
    //
    // }
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/test').create(recursive: true);
    final String filePath = widget.randomPhotoName
        ? '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4'
        : '${testDir.path}/video_test.mp4';
    // await VideoCompress.setLogLevel(0);
    // final mediaInfo = await VideoCompress.compressVideo(
    //   filePath,
    //   quality: VideoQuality.MediumQuality,
    //   deleteOrigin: false,
    //   includeAudio: true,// It's false by default
    // );
    await _videoController.recordVideo(filePath);
    _isRecordingVideo = true;
    _lastVideoPath = filePath;
    setState(() {});
    print("seconds_15 $seconds_15");
    print("seconds_60 $seconds_60");
    if (seconds_15) {
      startTimer_15();
      Future.delayed(const Duration(seconds: 17), () {
        _stopvideo();
      });
    } else if (seconds_60) {
      startTimer_60();
      Future.delayed(const Duration(seconds: 62), () {
        _stopvideo();
      });
    }

    // startWatch();
  }

  _buildChangeResolutionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => ListTile(
          key: ValueKey("resOption"),
          onTap: () {
            this._photoSize.value = _availableSizes![index];
            setState(() {});
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.aspect_ratio),
          title: Text(
              "${_availableSizes![index].width}/${_availableSizes![index].height}"),
        ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: _availableSizes!.length,
      ),
    );
  }

  _onOrientationChange(CameraOrientations? newOrientation) {
    _orientation.value = newOrientation!;
    if (_previewDismissTimer != null) {
      _previewDismissTimer!.cancel();
    }
  }

  _onPermissionsResult(bool? granted) {
    if (!granted!) {
      AlertDialog alert = AlertDialog(
        title: Text('Error'),
        content: Text(
            'It seems you doesn\'t authorized some permissions. Please check on your settings and try again.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      setState(() {});
      print("granted");
    }
  }

  // /// this is just to preview images from stream
  // /// This use a bufferTime to take an image each 1500 ms
  // /// you cannot show every frame as flutter cannot draw them fast enough
  // /// [THIS IS JUST FOR DEMO PURPOSE]
  // Widget _buildPreviewStream() {
  //   if (previewStream == null) return Container();
  //   return Positioned(
  //     left: 32,
  //     bottom: 120,
  //     child: StreamBuilder(
  //       stream: previewStream.bufferTime(Duration(milliseconds: 1500)),
  //       builder: (context, snapshot) {
  //         print(snapshot);
  //         if (!snapshot.hasData || snapshot.data == null) return Container();
  //         List<Uint8List> data = snapshot.data;
  //         print(
  //             "...${DateTime.now()} new image received... ${data.last.lengthInBytes} bytes");
  //         return Image.memory(
  //           data.last,
  //           width: 120,
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget buildFullscreenCamera() {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      child: Center(
        child: CameraAwesome(
          onPermissionsResult: _onPermissionsResult,
          selectDefaultSize: (availableSizes) {
            this._availableSizes = availableSizes;
            return availableSizes[0];
          },
          captureMode: _captureMode,
          photoSize: _photoSize,
          sensor: _sensor,
          enableAudio: _enableAudio,
          switchFlashMode: _switchFlash,
          zoom: _zoomNotifier,
          onOrientationChanged: _onOrientationChange,
          // imagesStreamBuilder: (imageStream) {
          //   /// listen for images preview stream
          //   /// you can use it to process AI recognition or anything else...
          //   print("-- init CamerAwesome images stream");
          //   setState(() {
          //     previewStream = imageStream;
          //   });

          //   imageStream.listen((Uint8List imageData) {
          //     print(
          //         "...${DateTime.now()} new image received... ${imageData.lengthInBytes} bytes");
          //   });
          // },
          onCameraStarted: () {
            // camera started here -- do your after start stuff
          },
        ),
      ),
    );
  }

  Widget buildSizedScreenCamera() {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      child: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: CameraAwesome(
              onPermissionsResult: _onPermissionsResult,
              selectDefaultSize: (availableSizes) {
                this._availableSizes = availableSizes;
                return availableSizes[0];
              },
              captureMode: _captureMode,
              photoSize: _photoSize,
              sensor: _sensor,
              fitted: true,
              switchFlashMode: _switchFlash,
              zoom: _zoomNotifier,
              onOrientationChanged: _onOrientationChange,
            ),
          ),
        ),
      ),
    );
  }
}
