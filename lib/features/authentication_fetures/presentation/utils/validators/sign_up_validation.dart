// ignore_for_file: file_names

import 'package:email_validator/email_validator.dart';

class SignUpValidation {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
    }

    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.trim().length > 45) {
      return 'Maximum 45 characters or spaces allowed';
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
    if (value.trim().length > 40) {
      return 'Maximum 40 characters or spaces allowed';
    }
    if (!value.endsWith("@gmail.com") &&
        !value.endsWith("@outlook.com") &&
        !value.endsWith("@yahoo.com")) {
      return "Only @gmail.com, @outlook.com, and @yahoo.com email addresses are allowed";
    }
    return null;
  }

  static String? validateAcademyEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address";
    }
    if (!EmailValidator.validate(value)) {
      return "Please enter a valid email address";
    }
    if (value.trim().length > 40) {
      return 'Maximum 40 characters or spaces allowed';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.contains(' ')) {
      return 'Spaces are not allowed';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Special characters are not allowed in the username';
    }
    if (value.length < 4) {
      return 'Username must be at least 4 characters long';
    }
    if (value.length > 40) {
      return 'Maximum 40 characters allowed';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    // if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
    //     .hasMatch(value)) {
    //   return "Password must contain at least one uppercase letter, one lowercase letter, and one number";
    // }
    if (value.length < 6) {
      return "Password must be at least 8 characters long";
    }
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

  static String? validateEinNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter the EIN number";
    }
    if (value.length < 4) {
      return "EIN number must be at least 4 digits long";
    }
    if (value.trim().length > 40) {
      return 'Maximum 40 characters or spaces allowed';
    }
    return null;
  }

  static String? validateContactInfo(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter the contact information";
    }

    if (value.length < 20) {
      return "Its too short...";
    }
    return null;
  }
}
