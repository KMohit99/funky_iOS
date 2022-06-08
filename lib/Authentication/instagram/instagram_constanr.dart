class InstagramConstant {
  static InstagramConstant? _instance;
  static InstagramConstant get instance {
    _instance ??= InstagramConstant._init();
    return _instance!;
  }

  InstagramConstant._init();

  static const String clientID = '731998097813311';
  static const String appSecret = '894bc6d7a0c915b654daeaec2434ca4b';
  static const String redirectUri = 'https://github.com/KMohit99';
  static const String scope = 'user_profile,user_media';
  static const String responseType = 'code';
  final String url =
      'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=$responseType';
}
class Constants {
  static const igClientId = "731998097813311";
  static const igClientSecret = "894bc6d7a0c915b654daeaec2434ca4b";
  static const igRedirectURL = "https://github.com/KMohit99";
}