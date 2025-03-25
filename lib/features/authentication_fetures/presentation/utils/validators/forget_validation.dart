class ForgetValidation {
  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value!)) {
      return 'Invalid email format';
    }
    // if (!value.endsWith("@gmail.com") && !value.endsWith("@outlook.com")) {
    //   return "Only @gmail.com and @outlook.com  are accepted";
    // }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Username cannot be empty';
    }
    if (value!.trim().isEmpty) {
      return 'Invalid username';
    }
    return null;
  }
}
