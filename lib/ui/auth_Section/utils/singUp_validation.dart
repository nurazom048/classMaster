import 'package:email_validator/email_validator.dart';

class SignUpValidation {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address";
    }
    if (!EmailValidator.validate(value)) {
      return "Please enter a valid email address";
    }
    if (!value.endsWith("@gmail.com") && !value.endsWith("@outlook.com")) {
      return "Only @gmail.com and @outlook.com  are accepted";
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a username";
    }
    if (value.length < 4) {
      return "Username must be at least 4 characters long";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 6) {
      return "Password must be at least 8 characters long";
    }
    // if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
    //     .hasMatch(value)) {
    //   return "Password must contain at least one uppercase letter, one lowercase letter, and one number";
    // }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }
}
