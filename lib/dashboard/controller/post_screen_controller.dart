import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';

class post_screen_controller extends GetxController{
  RxString file_selected_image = '_'.obs;
  RxString file_selected_video = '_'.obs;
  RxString selected_item = '_'.obs;


  Uint8List? image ;

  String pageIndex = '01';
  pageIndexUpdate(String? value) {
    pageIndex = value!;
    update();
  }
}