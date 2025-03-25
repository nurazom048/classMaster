class EdditAccountValidation {
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

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  static String? validateAbout(String? value) {
    //   if (value == null || value.isEmpty) {
    //     return 'Please write something about yourself';
    //   }
    return null;
  }
}
