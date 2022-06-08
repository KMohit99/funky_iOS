// import 'package:better_player/better_player.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../utils/asset_utils.dart';
//
// class VideoDetails extends StatefulWidget {
//   final String url;
//
//   const VideoDetails({Key? key, required this.url}) : super(key: key);
//
//   @override
//   _VideoDetailsState createState() => _VideoDetailsState();
// }
//
// class _VideoDetailsState extends State<VideoDetails>
//     with SingleTickerProviderStateMixin {
//   // final _video_screen_controller = Get.put(video_screen_controller());
//   GlobalKey<ScaffoldState>? _globalKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     // video_code();
//     better_player_code();
//     super.initState();
//   }
//
//   bool playing = false;
//
//   // video_code() {
//   //   _videoPlayerController = VideoPlayerController.asset(AssetUtils.vid_test)
//   //     ..initialize().then((_) {
//   //       setState(() {});
//   //       _videoPlayerController!.play();
//   //       playing = true;
//   //     });
//   // }
//
//   BetterPlayerController? _betterPlayerController;
//
//   better_player_code() {
//     BetterPlayerConfiguration betterPlayerConfiguration =
//     const BetterPlayerConfiguration(
//       aspectRatio: 9 / 16,
//       fit: BoxFit.contain,
//     );
//     BetterPlayerDataSource dataSource = BetterPlayerDataSource(
//         BetterPlayerDataSourceType.network, widget.url,
//         useAsmsSubtitles: true, useAsmsTracks: true);
//     _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
//     _betterPlayerController!.setupDataSource(dataSource);
//   }
//
//   @override
//   void dispose() {
//     // _videoPlayerController!.dispose();
//     _betterPlayerController!.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//
//     return Scaffold(
//       key: _globalKey,
//       extendBodyBehindAppBar: true,
//
//       body: Container(
//         height: screenSize.height,
//         margin: const EdgeInsets.only(top: 0, left: 5, right: 5),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: (screenSize.height * 0.118)),
//               // Stack(
//               //   fit: StackFit.loose, // Just Changed this line
//               //   alignment: Alignment.bottomRight,
//               //   children: [
//               //     ClipRRect(
//               //       borderRadius: BorderRadius.circular(10),
//               //       child: AspectRatio(
//               //           aspectRatio: 16 / 9,
//               //           child: SizedBox(
//               //             height: 100,
//               //             width: screenSize.width,
//               //             child: VideoPlayer(_videoPlayerController!),
//               //           )),
//               //     ),
//               //     Container(
//               //         alignment: FractionalOffset.bottomLeft,
//               //         // margin: EdgeInsets.only(top: 50),
//               //         child: Container(
//               //           decoration: BoxDecoration(
//               //               color: ColorUtils.white,
//               //               borderRadius: BorderRadius.only(
//               //                   bottomLeft: Radius.circular(10),
//               //                   bottomRight: Radius.circular(10))),
//               //           child: ListTile(
//               //             contentPadding: EdgeInsets.zero,
//               //             // tileColor: ColorUtils.orangeBack,
//               //             leading: SizedBox(
//               //               height: 50,
//               //               child: Container(
//               //                 // margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
//               //                 child: IconButton(
//               //                   padding: new EdgeInsets.all(0.0),
//               //                   // iconSize: 50,
//               //                   icon: Image.asset(
//               //                     AssetUtils.reddit_png,
//               //                   ),
//               //                   onPressed: () {},
//               //                 ),
//               //               ),
//               //             ),
//               //             title: Text(
//               //               "Title Here",
//               //               style: FontStyleUtility.h16(
//               //                   fontColor: ColorUtils.black,
//               //                   fontWeight: FWT.semiBold),
//               //             ),
//               //             subtitle: Text(
//               //               "subtitel here",
//               //               style: FontStyleUtility.h12(
//               //                   fontColor:
//               //                       ColorUtils.black.withOpacity(0.6),
//               //                   fontWeight: FWT.semiBold),
//               //             ),
//               //           ),
//               //         )),
//               //   ],
//               // ),
//               SizedBox(
//                 height: 20,
//               ),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: BetterPlayer(
//                       controller: _betterPlayerController!),
//                 ),
//               ),
//               SizedBox(
//                   height: (screenSize.height * 0.02).ceilToDouble()),
//               Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: ListTileTheme(
//                   contentPadding: EdgeInsets.zero,
//                   dense: true,
//                   horizontalTitleGap: 0.0,
//                   minLeadingWidth: 0,
//                   minVerticalPadding: 0,
//                   child: ExpansionTile(
//                     childrenPadding: const EdgeInsets.only(
//                         left: 15, right: 15, bottom: 15),
//                     textColor: Colors.black,
//                     initiallyExpanded: true,
//
//                     title: Text(
//                       "Title Here",
//
//                     ),
//                     subtitle: Text(
//                       "subtitel here",
//
//                     ),
//
//                     trailing: const SizedBox.shrink(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DurationState {
//   const DurationState({
//     required this.progress,
//     required this.buffered,
//     this.total,
//   });
//
//   final Duration progress;
//   final Duration buffered;
//   final Duration? total;
// }