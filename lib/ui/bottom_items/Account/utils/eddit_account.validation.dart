class EdditAccountValidation {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  static String? validateAbout(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please write something about yourself';
    }
    return null;
  }
}
