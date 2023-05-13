class ChangePwValidator {
  static String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    // Add custom validation logic if needed
    return null;
  }

  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    // Additional validations for the new password
    if (value.length < 6) {
      return 'Password should have at least 8 characters';
    }
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(value)) {
    //   return 'Password should contain at least one uppercase letter, one lowercase letter, and one digit';
    // }
    return null;
  }

  static String? validateConfirmPassword(String? value, String newPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }
    // Additional validation to check if the new password and confirm password match
    if (value != newPassword) {
      return 'New password and confirm password do not match';
    }
    return null;
  }
}
