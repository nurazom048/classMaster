class LoginValidation {
  //final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // if (value.length < 6) {
    //   return 'Password must be at least 6 characters long';
    // }
    return null;
  }
}
