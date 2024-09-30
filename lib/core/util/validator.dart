class Validator {
  static String? validateEmail(String value) {
    Pattern pattern =
        r'^[^\s@]+@[^\s@]+\.[^\s@]+$'; // Updated email regex for stricter validation
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value)) {
      return ' Please enter a valid email address.';
    } else {
      return null;
    }
  }

  static String? validateDropDefaultData(value) {
    if (value == null) {
      return 'Please select an item.';
    } else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    if (value == null || value.isEmpty) {
      // Improved validation for empty password
      return ' Password cannot be empty.';
    } else if (value.length < 6) {
      return ' Password must be at least 6 characters.';
    } else {
      return null;
    }
  }

  static String? validateName(String value) {
    if (value.length < 3) {
      return ' Username is too short.';
    } else {
      return null;
    }
  }

  static String? validateBloodGroup(String value) {
    if (value.isEmpty) {
      return 'Please select blood group';
    } else {
      return null;
    }
  }

  static String? validateText(String value) {
    if (value.isEmpty) {
      return ' Text is too short.';
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String value) {
    Pattern pattern = r'^[0-9]{10}$'; // Phone number pattern for 11 digits
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value)) {
      return ' Phone number is not valid.';
    } else {
      return null;
    }
  }
}