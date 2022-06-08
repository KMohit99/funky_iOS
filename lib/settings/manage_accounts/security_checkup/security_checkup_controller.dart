import 'package:get/get.dart';

class Security_checkup_screen_controller extends GetxController {
  String pageIndex_email = '01';
  pageIndexUpdateEmail(String? value) {
    pageIndex_email = value!;
    update();
  }
  String pageIndex_mobile = '01';
  pageIndexUpdatephone(String? value) {
    pageIndex_mobile = value!;
    update();
  }

}