// ignore_for_file: non_constant_identifier_names, constant_identifier_names

abstract class Const {
  //static String BASE_URl = "http://localhost:3000";

  //adb
  static String BASE_URl = "http://10.0.2.2:3000";
  // static String BASE_URl = "http://192.168.31.229:3000";
  //static String BASE_URl = "https://noticeapp-ifsc.onrender.com";

  // static String BASE_URl = "http://192.168.0.125:3000";

  //  image

  static String accountimage =
      "https://th.bing.com/th/id/OIP.iSu2RcCcdm78xbxNDJMJSgHaEo?pid=ImgDet&rs=1";

  static String CANT_SEE_SUMMARYS =
      'You are not a member of this routine.\nTo view the summary,\nyou need to become a member first.';

// signUp info textList
  static List<String> SignUpInfoText = [
    "To create a academy account , it may take time to physically verify your academy",
    'This information will allow our team to visit your academy physically for verification.',
    'fill out the form and send a request to our team . We will review your request and accept it as soon as possible.',
    'Don\'t worry, this contact information will not be visible to the public'
  ];
}

double KTopPadding = 25;

const String FORGOT_MAIL_SEND_MESSAGE =
    'Reset email has been sent. Please check your Inbox and set a new password. If you don\'t find this email in your inbox, please check your spam folder.';

const String FORGOT_MAIL_SEND_MESSAGE_WILL_SEND =
    'After sending the password reset email, please check your Inbox and set a new password.\n\nIf you don\'t find this email in your inbox, please check your spam folder.';
