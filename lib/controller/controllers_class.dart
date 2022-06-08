import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../getx_pagination/binding_utils.dart';

class SplashScreenController extends GetxController {
  checkForLogin() {
    Get.toNamed(BindingUtils.creator_loginScreenRoute);
    // Get.toNamed(BindingUtils.purchaseRoute);
  }
}
class Authentication_controller extends GetxController {
  bool isPasswordVisible = false;
  isPasswordVisibleUpdate(bool value) {
    isPasswordVisible = value;
    update();
  }
}


class Age_screen_controller extends GetxController {
  bool isPasswordVisible = false;
  isPasswordVisibleUpdate(bool value) {
    isPasswordVisible = value;
    update();
  }
}
class SignUp_option_controller extends GetxController {
  bool isPasswordVisible = false;
  isPasswordVisibleUpdate(bool value) {
    isPasswordVisible = value;
    update();
  }
}






