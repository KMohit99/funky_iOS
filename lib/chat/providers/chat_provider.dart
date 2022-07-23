import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firestore_constants.dart';
import '../models/message_chat.dart';

class ChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatProvider({required this.firebaseFirestore, required this.prefs, required this.firebaseStorage});

  String? getPref(String key) {
    return prefs.getString(key);
  }

  UploadTask uploadImage(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child('images').child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    print("uploadTask");
    print(uploadTask);
    return uploadTask;
  }
  // StorageUploadTask uploadTask = ref.putFile(file, StorageMetadata(contentType: 'video/mp4')); <- this content type does the trick


  UploadTask uploadVideo(File image, String fileName) {
    final metadata = SettableMetadata(
      contentType:'video/mp4',
      customMetadata: {'picked-file-path': image.path},
    );
    Reference reference = firebaseStorage.ref().child('videos').child(fileName);
    UploadTask uploadTask = reference.putFile(image, metadata);
    print("uploadTask");
    print(uploadTask);
    return uploadTask;
  }

  UploadTask uploadPdf(File fileBytes, String fileName) {
    // final metadata = SettableMetadata(
    //   contentType:'pdf',
    // );
    Reference reference = firebaseStorage.ref().child('files').child(fileName);
    UploadTask uploadTask = reference.putFile(fileBytes);
    print("uploadTask");
    print(uploadTask);
    return uploadTask;
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath, Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore.collection(collectionPath).doc(docPath).update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendMessage(String content, int type, String groupChatId, String currentUserId, String peerId, String filename) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
      filename: filename,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }
}

class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
  static const video = 3;
  static const pdf = 4;
}
