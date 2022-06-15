import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class TxtUtils {
  static const Login_type_creator= 'creator';
  static const Login_type_kids= 'kids';
  static const Login_type_advertiser= 'advertiser';
  static const forgot_password= 'Forgot password?';
  static const otp_details= 'OTP has been sent to your email address';

  static const FullName = 'Full name';
  static const UserName = 'User name(unique)';
  static const Email = 'Email Address';
  static const phone = 'Phone';
  static const parents_email = 'Parents Email';
  static const Password = 'Password';
  static const Gender = 'Gender';
  static const Location = 'Location';
  static const ReffrelCode = 'Referral code (Optional)';
  static const CountryCode = 'Country code';
  static const AboutMe = 'About Me';
//drawer
  static const photos = 'My Photos';
  static const settings = 'Settings';
  static const qr_code = 'My Qr';
  static const analytics = 'Anlytics';
  static const manage_ac = 'Manage Accounts';
  static const rewards = 'Rewards';
  static const t_c = 'Terms & Conditions';
  static const help = 'Help';

}
class URLConstants{
  static const String base_url = "http://foxyserver.com/funky/api/";
  static const loginApi = "login.php";
  static const SignUpApi = "signup.php";
  static const socailsignUpApi = "social-signup.php";
  static const parentOtpVeri_Api = "parent-otp.php";
  static const creatorsend_Api = "send-otp.php";
  static const creatorverify_Api = "otp-verify.php";

  static const password_reset_Api = "forgot-password.php";
  static const password_verify_Api = "forgot-otp-verify.php";
  static const new_password_Api = "create-pssword.php";

  static const user_info_email_Api = "get-profile.php";
  static const user_info_social_Api = "get-socialprofile.php";


  static const VideoListApi = "videoList.php";
  static const FollowersListApi = "get-followUsers.php";
  static const followingListApi = "followingList";
  static const CountryListApi = "getCountry.php";
  static const searchListApi = "search_users.php";
  static const blockListApi = "user-block-list.php";
  static const NewsFeedApi = "news-feeds.php";
  static const postApi = "post.php";
  static String id = "id";
  static String type = "type";
  static String social_type = "type";


}
class CommonService {
  final box = GetStorage();

  void setStoreKey({required String setKey, required String setValue}) async {
    debugPrint(
        '********** Store Storage ${setKey.toString()} = ${setValue
            .toString()}');
    await box.write(setKey, setValue);
  }
  //
  // void setPermissions({required String setKey, required List setValue}) async {
  //   debugPrint(
  //       '********** Store Storage ${setKey.toString()} = ${setValue
  //           .toString()}');
  //   await box.write(setKey, setValue);
  // }

  String getStoreValue({required String keys}) {
    return box.read(keys).toString();
  }
}