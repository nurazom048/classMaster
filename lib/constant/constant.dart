// ignore_for_file: non_constant_identifier_names, constant_identifier_names

abstract class Const {
  //static String BASE_URl = "http://localhost:3000";
  static String BASE_URl = "http://192.168.31.229:3000";

  // static String BASE_URl = "http://192.168.0.125:3000";

  //  image

  static String accountimage =
      "https://th.bing.com/th/id/OIP.iSu2RcCcdm78xbxNDJMJSgHaEo?pid=ImgDet&rs=1";

  static String CANT_SEE_SUMMARYS =
      'You are not a member of this routine.\nTo view the summary,\nyou need to become a member first.';
}

Future<String> BASE_URL() async {
  await Future.delayed(Duration(seconds: 1));
  return 'http://192.168.31.229:3000';
}

const String FORGOT_MAIL_SEND_MESSAGE =
    'Reset email has been sent. Please check your email and set a new password. If you don\'t find this email in your inbox, please check your spam box.';

const String FORGOT_MAIL_SEND_MESSAGE_WILL_SEND =
    'After sending the password reset email, please check your email and set a new password. If you don\'t find this email in your inbox, please check your spam box.';
