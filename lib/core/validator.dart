class Validator{
  static String? validateName(String? value){
    String pattern = r'^[a-z A-Z]*$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
     else if (!regex.hasMatch(value)) {
      return 'Enter a valid name';
    }
    else if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    String pattern = r'^[^@]+@[^@]+\.[^@]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
  static String? validateConfirmPassword(String? value,String? pass) {
    if(value == null ||value.isEmpty)
      return 'Empty';
    if(value != pass)
      return 'Not Match';
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    String pattern = r'^(01)[0-9]{9}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of players cannot be empty';
    }
    try{
    if (int.parse(value) <= 0) {
      return 'Number of players must be positive';
    }}catch(e){
      return 'Number of players must be numbers only';
    }
    return null;
  }

}