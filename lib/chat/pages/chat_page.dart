import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:funky_new/Utils/toaster_widget.dart';
import 'package:funky_new/profile_screen/video_viewer.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../Utils/asset_utils.dart';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';
import '../models/message_chat.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/widgets.dart';
import 'full_pdf_page.dart';
import 'full_video_page.dart';
import 'pages.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.arguments}) : super(key: key);

  final ChatPageArguments arguments;

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";

  File? imageFile;
  String filename = '';
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }

    chatProvider.updateDataFirestore(
      FirestoreConstants.pathUserCollection,
      currentUserId,
      {FirestoreConstants.chattingWith: peerId},
    );
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      filename = pickedFile.name;
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile_image();
      }
    }
  }

  Future getVideo() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickVideo(source: ImageSource.gallery);

    int sizeInBytes = File(pickedFile!.path).lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    print("sizeInMb $sizeInMb");

    if (sizeInMb > 25) {
      CommonWidget()
          .showErrorToaster(msg: "File's Too large"); // This file is Longer the
    } else {
      imageFile = File(pickedFile.path);
      filename = pickedFile.name;
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile_video();
      }
    }
  }

  Future getFile() async {
    // ImagePicker imagePicker = ImagePicker();
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'ppt',
        'docx',
        'pptx',
        'xls',
        'xlsx',
        'zip',
        'txt',
      ],
    ); // pickedFile = await imagePicker.pickVideo(source: ImageSource.gallery);
    // print(File(pickedFile!.files.first.path!).readAsBytesSync());

    int sizeInBytes = pickedFile!.files.first.size;
    print("sizeInBytes  ${sizeInBytes}");
    double sizeInMb = sizeInBytes / (1024 * 1024);
    print("sizeInMb $sizeInMb");
    if (sizeInMb > 25) {
      CommonWidget()
          .showErrorToaster(msg: "File's Too large"); // This file is Longer the
    } else {
      imageFile = File(pickedFile.files.first.path!);
      filename = pickedFile.files.first.name;
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile_pdf();
      }
    }
  }

  Future uploadFile_image() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadImage(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      print(imageUrl);

      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, TypeMessage.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future uploadFile_video() async {
    print('inside upload video');
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    print(imageFile);
    UploadTask uploadTask = chatProvider.uploadVideo(
      imageFile!,
      fileName,
    );
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, TypeMessage.video);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future uploadFile_pdf() async {
    // filename = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadPdf(
      imageFile!,
      filename!,
    );
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(
          imageUrl,
          TypeMessage.pdf,
        );
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(content, type, groupChatId, currentUserId,
          widget.arguments.peerId, filename!);
      listScrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

  void downloadFileandOpen(
      BuildContext context, String url, String fileName) async {
    var directory = await getApplicationSupportDirectory();

    String dir = directory.path;

    File file = File('$dir/$fileName');

    if (await file.exists()) {
      OpenFile.open(file.path);
    } else {
      CommonWidget().showToaster(msg: "Downloading...");

      HttpClient httpClient = new HttpClient();

      try {
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        print(response.statusCode);
        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          print(file.path);
          await file.writeAsBytes(bytes);
        }
        // Navigator.pop(context);
      } catch (ex) {
        Navigator.pop(context);
        print(ex.toString());
        CommonWidget().showToaster(msg: ex.toString());
      } finally {
        OpenFile.open(file.path);
      }
    }
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        // Right (my message)
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            messageChat.type == TypeMessage.text

                /// Text
                ? Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    // width: 200,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1.5,
                    ),

                    // width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        color: HexColor('#E8E7E7'),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          messageChat.content,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PB',
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0, top: 5, bottom: 0),
                          child: Text(
                            DateFormat('dd MMM kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(messageChat.timestamp))),
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                                fontFamily: 'PM',
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                  )
                : messageChat.type == TypeMessage.image

                    /// Image
                    ? Container(
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20 : 10,
                            right: 10),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullPhotoPage(
                                    url: messageChat.content,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      child: Image.network(
                                        messageChat.content,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: ColorConstants.greyColor2,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(0),
                                              ),
                                            ),
                                            width: 200,
                                            height: 200,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    ColorConstants.themeColor,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, object, stackTrace) {
                                          return Material(
                                            child: Image.asset(
                                              'images/img_not_available.jpeg',
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                          );
                                        },
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 0, top: 5, bottom: 0),
                                      child: Text(
                                        DateFormat('dd MMM kk:mm').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                    messageChat.timestamp))),
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10,
                                            fontFamily: 'PM',
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      )

                    /// Sticker
                    : messageChat.type == TypeMessage.video

                        /// Video
                        ? Container(
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20 : 10,
                                right: 10),
                            child: GestureDetector(
                              onTap: () {
                                print(messageChat.type);
                                print(messageChat.content);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullVideoPage(
                                      url: messageChat.content,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        clipBehavior: Clip.hardEdge,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/Funky_App_Icon.png',
                                              // messageChat.content,
                                              // loadingBuilder: (BuildContext context,
                                              //     Widget child,
                                              //     ImageChunkEvent? loadingProgress) {
                                              //   if (loadingProgress == null) return child;
                                              //   return Container(
                                              //     decoration: BoxDecoration(
                                              //       color: ColorConstants.greyColor2,
                                              //       borderRadius: BorderRadius.all(
                                              //         Radius.circular(0),
                                              //       ),
                                              //     ),
                                              //     width: 200,
                                              //     height: 200,
                                              //     child: Center(
                                              //       child: CircularProgressIndicator(
                                              //         color: ColorConstants.themeColor,
                                              //         value: loadingProgress
                                              //                     .expectedTotalBytes !=
                                              //                 null
                                              //             ? loadingProgress
                                              //                     .cumulativeBytesLoaded /
                                              //                 loadingProgress
                                              //                     .expectedTotalBytes!
                                              //             : null,
                                              //       ),
                                              //     ),
                                              //   );
                                              // },
                                              errorBuilder: (context, object,
                                                  stackTrace) {
                                                return Material(
                                                  child: Image.asset(
                                                    'images/img_not_available.jpeg',
                                                    width: 200,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                );
                                              },
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                            Icon(
                                              Icons.play_circle_fill,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 0, top: 5, bottom: 0),
                                        child: Text(
                                          DateFormat('dd MMM kk:mm').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      int.parse(messageChat
                                                          .timestamp))),
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 10,
                                              fontFamily: 'PM',
                                              fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : messageChat.type == TypeMessage.pdf

                            /// file
                            ? Container(
                                margin: EdgeInsets.only(
                                    bottom: isLastMessageRight(index) ? 20 : 10,
                                    right: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    print(messageChat.type);
                                    print(messageChat.content);
                                    downloadFileandOpen(
                                        context,
                                        messageChat.content,
                                        messageChat.filename);

                                    // await _prepareSaveDir();
                                    // print("Downloading");
                                    // try {
                                    //   await Dio().download(messageChat.content,
                                    //       "${_localPath!}/${messageChat.filename}");
                                    //   print("Download Completed.");
                                    // } catch (e) {
                                    //   print("Download Failed.\n\n$e");
                                    // }

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => FullPdfPage(
                                    //       filename: filename!,
                                    //       url: messageChat.content,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    // constraints: BoxConstraints(
                                    //     minWidth: 100,
                                    //     maxWidth:
                                    //         MediaQuery.of(context).size.width /
                                    //             1.5),
                                    // width:
                                    //     MediaQuery.of(context).size.width / 2,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.pink
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.insert_drive_file,
                                                    color: Colors.pink,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // width: 110,
                                                    child: Text(
                                                      messageChat.filename,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              CommonColor
                                                                  .pinkFont),
                                                          fontSize: 14,
                                                          fontFamily: 'PR'),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 0, top: 5, bottom: 0),
                                            child: Text(
                                              DateFormat('dd MMM kk:mm').format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          int.parse(messageChat
                                                              .timestamp))),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 10,
                                                  fontFamily: 'PM',
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )

                            /// Sticker
                            : Container(
                                child: Image.asset(
                                  'assets/images/${messageChat.content}.gif',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(
                                    bottom: isLastMessageRight(index) ? 20 : 10,
                                    right: 10),
                              ),
          ],
        );
      } else {
        // Left (peer message)
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              widget.arguments.peerAvatar,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstants.themeColor,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return Icon(
                                  Icons.account_circle,
                                  size: 35,
                                  color: ColorConstants.greyColor,
                                );
                              },
                              width: 35,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(width: 35),
                  SizedBox(
                    width: 10,
                  ),
                  messageChat.type == TypeMessage.text

                      ///text
                      ? Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width / 1.5,
                              ),

                              // width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  color: HexColor('#641637'),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))),
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messageChat.content,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'PR',
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  isLastMessageLeft(index)
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: 0, top: 5, bottom: 0),
                                          child: Text(
                                            DateFormat('dd MMM kk:mm').format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        int.parse(messageChat
                                                            .timestamp))),
                                            style: TextStyle(
                                                color: ColorConstants.greyColor,
                                                fontSize: 10,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        )
                                      : SizedBox.shrink()
                                ],
                              ),
                            ),
                          ],
                        )
                      : messageChat.type == TypeMessage.image

                          ///images
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullPhotoPage(
                                              url: messageChat.content),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.network(
                                                messageChat.content,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: ColorConstants
                                                          .greyColor2,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(38),
                                                      ),
                                                    ),
                                                    width: 200,
                                                    height: 200,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: ColorConstants
                                                            .themeColor,
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, object,
                                                        stackTrace) =>
                                                    Material(
                                                  child: Image.asset(
                                                    'images/img_not_available.jpeg',
                                                    width: 200,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                ),
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, top: 5, bottom: 0),
                                              child: Text(
                                                DateFormat('dd MMM kk:mm')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            int.parse(messageChat
                                                                .timestamp))),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 10,
                                                    fontFamily: 'PM',
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : messageChat.type == TypeMessage.video

                              ///video
                              ? Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      print(messageChat.type);
                                      print(messageChat.content);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullVideoPage(
                                            url: messageChat.content,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              clipBehavior: Clip.hardEdge,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/Funky_App_Icon.png',
                                                    // messageChat.content,
                                                    // loadingBuilder: (BuildContext context,
                                                    //     Widget child,
                                                    //     ImageChunkEvent? loadingProgress) {
                                                    //   if (loadingProgress == null) return child;
                                                    //   return Container(
                                                    //     decoration: BoxDecoration(
                                                    //       color: ColorConstants.greyColor2,
                                                    //       borderRadius: BorderRadius.all(
                                                    //         Radius.circular(0),
                                                    //       ),
                                                    //     ),
                                                    //     width: 200,
                                                    //     height: 200,
                                                    //     child: Center(
                                                    //       child: CircularProgressIndicator(
                                                    //         color: ColorConstants.themeColor,
                                                    //         value: loadingProgress
                                                    //                     .expectedTotalBytes !=
                                                    //                 null
                                                    //             ? loadingProgress
                                                    //                     .cumulativeBytesLoaded /
                                                    //                 loadingProgress
                                                    //                     .expectedTotalBytes!
                                                    //             : null,
                                                    //       ),
                                                    //     ),
                                                    //   );
                                                    // },
                                                    errorBuilder: (context,
                                                        object, stackTrace) {
                                                      return Material(
                                                        child: Image.asset(
                                                          'images/img_not_available.jpeg',
                                                          width: 200,
                                                          height: 200,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(8),
                                                        ),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                      );
                                                    },
                                                    width: 200,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Icon(
                                                    Icons.play_circle_fill,
                                                    color: Colors.white,
                                                    size: 35,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, top: 5, bottom: 0),
                                              child: Text(
                                                DateFormat('dd MMM kk:mm')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            int.parse(messageChat
                                                                .timestamp))),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 10,
                                                    fontFamily: 'PM',
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : messageChat.type == TypeMessage.pdf

                                  ///file
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          bottom:
                                              isLastMessageRight(index) ? 0 : 0,
                                          right: 10),
                                      child: GestureDetector(
                                        onTap: () async {
                                          print(messageChat.type);
                                          print(messageChat.content);
                                          downloadFileandOpen(
                                              context,
                                              messageChat.content,
                                              messageChat.filename);

                                          // await _prepareSaveDir();
                                          // print("Downloading");
                                          // try {
                                          //   await Dio().download(messageChat.content,
                                          //       "${_localPath!}/${messageChat.filename}");
                                          //   print("Download Completed.");
                                          // } catch (e) {
                                          //   print("Download Failed.\n\n$e");
                                          // }

                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => FullPdfPage(
                                          //       filename: filename!,
                                          //       url: messageChat.content,
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                        child: Container(
                                          // width: MediaQuery.of(context)
                                          //         .size
                                          //         .width /
                                          //     2,
                                          decoration: const BoxDecoration(
                                              color: Colors.pink,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white30,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .insert_drive_file,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          // width: 110,
                                                          child: Text(
                                                            messageChat
                                                                .filename,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: TextStyle(
                                                                color: HexColor(
                                                                    '#ffffff'),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'PR'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 0,
                                                      top: 5,
                                                      bottom: 0),
                                                  child: Text(
                                                    DateFormat('dd MMM kk:mm')
                                                        .format(DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                int.parse(
                                                                    messageChat
                                                                        .timestamp))),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontFamily: 'PM',
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  // Sticker
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            'assets/images/${messageChat.content}.gif',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          margin: EdgeInsets.only(
                                              bottom: isLastMessageRight(index)
                                                  ? 20
                                                  : 10,
                                              right: 10),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        isLastMessageLeft(index)
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                    left: 0, top: 5, bottom: 0),
                                                child: Text(
                                                  DateFormat('dd MMM kk:mm')
                                                      .format(DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              int.parse(messageChat
                                                                  .timestamp))),
                                                  style: const TextStyle(
                                                      color: ColorConstants
                                                          .greyColor,
                                                      fontSize: 10,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              )
                                            : SizedBox.shrink()
                                      ],
                                    ),
                ],
              ),
              // Time
              // isLastMessageLeft(index)
              //     ? Container(
              //         child: Text(
              //           DateFormat('dd MMM kk:mm').format(
              //               DateTime.fromMillisecondsSinceEpoch(
              //                   int.parse(messageChat.timestamp))),
              //           style: TextStyle(
              //               color: ColorConstants.greyColor,
              //               fontSize: 12,
              //               fontStyle: FontStyle.italic),
              //         ),
              //         margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
              //       )
              //     : SizedBox.shrink()
            ],
          ),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateDataFirestore(
        FirestoreConstants.pathUserCollection,
        currentUserId,
        {FirestoreConstants.chattingWith: null},
      );
      Navigator.pop(context);
    }

    return Future.value(false);
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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              backgroundColor: HexColor('#641637'),
              title: Text(
                widget.arguments.peerNickname.capitalize!,
                style: const TextStyle(
                    fontSize: 16, color: Colors.white, fontFamily: 'PM'),
              ),
              centerTitle: true,
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.only(right: 20.0, top: 0.0, bottom: 5.0),
                    child: ClipRRect(
                      child: Icon(
                        Icons.delete,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                )
              ],
              leadingWidth: 100,
              leading: Container(
                margin: const EdgeInsets.only(left: 0, top: 0, bottom: 0),
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
          // AppBar(
          //   backgroundColor: Colors.transparent,
          //   title: Text(
          //     this.widget.arguments.peerNickname,
          //     style: TextStyle(color: ColorConstants.primaryColor),
          //   ),
          //   centerTitle: true,
          // ),
          body: WillPopScope(
            onWillPop: onBackPress,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // List of messages
                    buildListMessage(),

                    // Sticker
                    isShowSticker ? buildSticker() : SizedBox.shrink(),

                    // Input content
                    buildInput(),
                  ],
                ),

                // Loading
                buildLoading()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSticker() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: ColorConstants.greyColor2, width: 0.5)),
            color: Colors.white),
        padding: EdgeInsets.all(5),
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi1', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi1.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage(
                    'mimi2',
                    TypeMessage.sticker,
                  ),
                  child: Image.asset(
                    'assets/images/mimi2.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage(
                    'mimi3',
                    TypeMessage.sticker,
                  ),
                  child: Image.asset(
                    'assets/images/mimi3.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi4', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi4.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi5', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi5.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi6', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi6.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi7', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi7.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi8', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi8.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi9', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi9.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? LoadingView() : SizedBox.shrink(),
    );
  }

  Future pop_up() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        elevation: 0.0,
        content: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          height: MediaQuery.of(context).size.height / 5,
          // width: 133,
          // padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.0, 0.0),
                end: const Alignment(1.0, 0.0),
                transform: const GradientRotation(0.7853982),
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  HexColor("#000000"),
                  HexColor("#000000"),
                  HexColor("##E84F90"),
                  HexColor("#ffffff"),
                  // HexColor("#FFFFFF").withOpacity(0.67),
                ],
              ),
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(26.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.image,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            getImage();
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            icon: const Icon(
                              Icons.video_camera_back_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              getVideo();
                            }),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.insert_drive_file,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            getFile();
                            Navigator.pop(context);
                            // camera_upload();
                          },
                        ),
                      ],
                    ),
                  )

                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      height: 65,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            // stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              HexColor("#000000"),
              HexColor("#000000"),
              HexColor("#C12265"),
              HexColor("#FFFFFF").withOpacity(0.97),
            ],
          ),
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(33),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          // Button send image

          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.emoji_emotions_outlined),
                onPressed: getSticker,
                color: Colors.white,
              ),
            ),
            color: Colors.transparent,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, TypeMessage.text);
                },
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'PM',
                ),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    color: HexColor(CommonColor.pinkFont),
                    fontSize: 14,
                    fontFamily: 'PM',
                  ),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 0),
              child: IconButton(
                visualDensity: VisualDensity(horizontal: -4),
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  pop_up();
                },
                color: Colors.white,
              ),
            ),
          ),
          // Material(
          //   color: Colors.transparent,
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 0),
          //     child: IconButton(
          //       visualDensity: VisualDensity(horizontal: -4),
          //       icon: Icon(Icons.image),
          //       onPressed: getImage,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // Material(
          //   color: Colors.transparent,
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 0),
          //     child: IconButton(
          //       visualDensity: VisualDensity(horizontal: -4),
          //       icon: Icon(Icons.video_camera_back),
          //       onPressed: getVideo,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // Button send message
          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.black,
                ),
                onPressed: () =>
                    onSendMessage(textEditingController.text, TypeMessage.text),
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.length > 0) {
                    return ListView.builder(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 110),
                      itemBuilder: (context, index) =>
                          buildItem(index, snapshot.data?.docs[index]),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    return Center(
                        child: Text(
                      "No message here yet...",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'PM', fontSize: 16),
                    ));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.themeColor,
                    ),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: ColorConstants.themeColor,
              ),
            ),
    );
  }
}

class ChatPageArguments {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPageArguments(
      {required this.peerId,
      required this.peerAvatar,
      required this.peerNickname});
}
