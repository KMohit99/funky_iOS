// import 'dart:convert';
// import 'dart:io';
// import 'dart:io' as Io;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:funky_new/custom_widget/page_loader.dart';
// import 'package:funky_new/profile_screen/profile_screen.dart';
// import 'package:get/get.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:http/http.dart' as http;
// import 'package:video_player/video_player.dart';
//
// import '../../Utils/App_utils.dart';
// import '../../Utils/asset_utils.dart';
// import '../../Utils/colorUtils.dart';
// import '../../Utils/custom_textfeild.dart';
// import '../../Utils/toaster_widget.dart';
// import '../../custom_widget/common_buttons.dart';
// import '../../sharePreference.dart';
// import '../dashboard/story_/stories_editor.dart';
//
// class ViewImageSelected extends StatefulWidget {
//   final List<File> imageData;
//
//   const ViewImageSelected({Key? key, required this.imageData})
//       : super(key: key);
//
//   @override
//   State<ViewImageSelected> createState() => _ViewImageSelectedState();
// }
//
// class _ViewImageSelectedState extends State<ViewImageSelected> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           // decoration: BoxDecoration(
//           //
//           //   image: DecorationImage(
//           //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
//           //     fit: BoxFit.cover,
//           //   ),
//           // ),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               // stops: [0.1, 0.5, 0.7, 0.9],
//
//               colors: [
//                 HexColor("#000000").withOpacity(0.67),
//                 HexColor("#000000").withOpacity(0.67),
//                 HexColor("#C12265").withOpacity(0.67),
//               ],
//             ),
//           ),
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.black,
//             title: Text(
//               ' Story',
//               style: TextStyle(
//                   fontSize: 16, color: Colors.white, fontFamily: 'PB'),
//             ),
//             centerTitle: true,
//             leadingWidth: 100,
//             leading: IconButton(
//                 padding: EdgeInsets.zero,
//                 onPressed: () {
//                   print('oject');
//                   // Navigator.pop(context);
//                 },
//                 icon: Icon(
//                   Icons.arrow_back_outlined,
//                   color: Colors.white,
//                 )),
//             actions: [
//               InkWell(
//                 onTap: () {
//                   // share_icon();
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(18.0),
//                   child: Image.asset(
//                     AssetUtils.share_icon,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             child: Container(
//               margin: EdgeInsets.symmetric(vertical: 40, horizontal: 0),
//               height: MediaQuery.of(context).size.height / 1.2,
//               width: MediaQuery.of(context).size.width,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: widget.imageData.length,
//                 shrinkWrap: true,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                     onTap: () async {
//                       File editedFile = await Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => StoriesEditor(
//                                     // fontFamilyList: font_family,
//                                     giphyKey: '',
//                                     imageData: widget.imageData,
//                                     onDone: (String) {},
//                                     // filePath:
//                                     //     imgFile!.path,
//                                   )));
//                           if (editedFile != null) {
//                             print('editedFile: ${editedFile.path}');
//                           }
//                     },
//                     child: Container(
//                       margin: EdgeInsets.all(10),
//                       child: Image.file(File(widget.imageData[index].path)),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
