class AddClassValidator {
  static String? className(String? value) {
    if (value == null || value.isEmpty) {
      return 'Class name is required';
    }
    if (value.trim().length > 30) {
      return 'Class name cannot exceed 30 words';
    }
    return null;
  }

  static String? instructorName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Instructor name is required';
    }
    if (value.trim().length > 20) {
      return 'Instructor name cannot exceed 20 words';
    }
    return null;
  }

  static String? roomNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Room number is required';
    }
    if (value.trim().length > 10) {
      return 'Room number cannot exceed 10 words';
    }
    return null;
  }

  static String? subCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Subject code is required';
    }
    if (value.trim().length > 10) {
      return 'Subject code cannot exceed 10 words';
    }
    return null;
  }

  static String? startPeriod(String? value) {
    if (value == null || value.isEmpty) {
      return 'Start period is required';
    }
    int start = int.tryParse(value) ?? 0;
    if (start <= 0) {
      return 'Start period must be a positive integer';
    }
    return null;
  }

  static String? endPeriod(String? value, String startPeriodValue) {
    if (value == null || value.isEmpty) {
      return 'End period is required';
    }
    int end = int.tryParse(value) ?? 0;
    if (end <= 0) {
      return 'End period must be a positive integer';
    }
    int start = int.tryParse(startPeriodValue) ?? 0;
    if (end < start) {
      return 'End period must be greater than or equal to start period';
    }
    return null;
  }
}
