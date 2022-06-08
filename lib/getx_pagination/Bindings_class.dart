
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../Authentication/advertiser_login/controller/advertiser_login_Controller.dart';
import '../Authentication/advertiser_signup/controller/advertiser_signup_controller.dart';
import '../Authentication/creator_signup/controller/creator_signup_controller.dart';
import '../Authentication/kids_login/controller/kids_login_controller.dart';
import '../Authentication/kids_signup/controller/kids_signup_controller.dart';
import '../Authentication/password_reset/controller/password_reset_controller.dart';
import '../controller/controllers_class.dart';
import '../homepage/controller/homepage_controller.dart';
class Splash_Bindnig implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController(), tag: SplashScreenController().toString());
  }
}

class Creator_Login_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(Kids_Login_screen_controller(), tag: Kids_Login_screen_controller().toString());
  }
}
class Kids_Login_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(Kids_Login_screen_controller(), tag: Kids_Login_screen_controller().toString());
  }
}
class Advertiser_Login_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(Advertiser_Login_screen_controller(), tag:Advertiser_Login_screen_controller().toString());
  }
}
class Authentication_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(Authentication_controller(), tag: Authentication_controller().toString());
  }
}

class AgeVerification_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(Age_screen_controller(), tag: Age_screen_controller().toString());
  }
}
class SignupOption_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(SignUp_option_controller(), tag: SignUp_option_controller().toString());
  }
}
class Creator_Signup_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(Creator_signup_controller(), tag: Creator_signup_controller().toString());
  }
}
class Kids_Signup_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(Kids_signup_controller(), tag:Kids_signup_controller().toString());
  }
}
class Advertiser_Signup_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(Advertiser_signup_controller(), tag:Advertiser_signup_controller().toString());
  }
}
class Password_reset_Binding implements Bindings {
  @override
  void dependencies() {
    Get.put(password_reset_controller(), tag:password_reset_controller().toString());
  }
}

class homePage_binding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomepageController(), tag:HomepageController().toString());
  }
}







