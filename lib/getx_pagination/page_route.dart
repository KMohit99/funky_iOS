
import 'package:get/route_manager.dart';

import '../Authentication/advertiser_login/ui/advertiser_login_screen.dart';
import '../Authentication/advertiser_signup/ui/advertiser_signup_screen.dart';
import '../Authentication/age_verificationScreen.dart';
import '../Authentication/authentication_screen.dart';
import '../Authentication/creator_login/ui/Creator_login_screen.dart';
import '../Authentication/creator_signup/ui/creator_signup.dart';
import '../Authentication/kids_login/ui/kids_login_screen.dart';
import '../Authentication/kids_signup/ui/kids_singup_screen.dart';
import '../Authentication/password_reset/ui/email_send.dart';
import '../Authentication/signup_option.dart';
import '../homepage/ui/homepage_screen.dart';
import '../splash_screen.dart';
import 'Bindings_class.dart';
import 'binding_utils.dart';

class AppPages {
  static final getPageList = [
    GetPage(
      name: BindingUtils.splashRoute,
      page: () => SplashScreen(),
      binding: Splash_Bindnig(),
    ),
    GetPage(
      name: BindingUtils.AuthenticationScreenRoute,
      page: () => AuthenticationScreen(),
      binding: Authentication_Binding(),
    ),
    GetPage(
      name: BindingUtils.creator_loginScreenRoute,
      page: () => CreatorLoginScreen(),
      binding: Creator_Login_Binding(),
    ),
    GetPage(
      name: BindingUtils.kids_loginScreenRoute,
      page: () => KidsLoginScreen(),
      binding: Kids_Login_Binding(),
    ),GetPage(
      name: BindingUtils.advertiser_loginScreenRoute,
      page: () => AdvertiserLoginScreen(),
      binding: Advertiser_Login_Binding(),
    ),
    GetPage(
      name: BindingUtils.ageVerification,
      page: () => AgeVerification(),
      binding: AgeVerification_Binding(),
    ),
    GetPage(
      name: BindingUtils.signupOption,
      page: () => SignupOption(),
      binding: SignupOption_Binding(),
    ),
    GetPage(
      name: BindingUtils.creator_signup,
      page: () => Creator_signup(),
      binding: Creator_Signup_Binding(),
    ),
    GetPage(
      name: BindingUtils.kids_signup,
      page: () => KidSignupScreen(),
      binding: Kids_Signup_Binding(),
    ),
    GetPage(
      name: BindingUtils.advertiser_signup,
      page: () => AdvertiserSignUpScreen(),
      binding: Advertiser_Signup_Binding(),
    ),
    // GetPage(
    //   name: BindingUtils.homepageRoute,
    //   page: () => HomePageScreen(),
    //   binding: homePage_binding(),
    // ),
    GetPage(
      name: BindingUtils.passwordreset,
      page: () => sendEmail(),
      binding: Password_reset_Binding(),
    ),
  ];
}
