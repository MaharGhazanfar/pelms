
class ModelValidation{

  static String? commonValidation( String value ){
    if (value.isNotEmpty) {
      return null;
    } else {
      return 'required';
    }

  }

  static String? gmailValidation(String value){
    if (value.isNotEmpty) {
      if (value.contains('@gmail.com') ||
          value.contains('@yahoo.com')) {
        return null;
      } else {
        return 'InValid gmail';
      }
    } else {
      return 'required';
    }
  }
  static String? passwordValidation(String value){
    if (value.isNotEmpty) {
      if (value.length == 8) {
        return null;
      } else {
        return 'Password Must be 8 characters';
      }
    } else {
      return 'required';
    }

  }

  static String? phoneNumberValidation(String value){
    if (value.isNotEmpty) {
      if (value.length == 11) {
        return null;
      } else {
        return 'InValid phone number';
      }
    } else {
      return 'required';
    }

  }

  static String? cnicValidation(String value){
    if (value.isNotEmpty) {
      if (value.length == 15) {
        return null;
      } else {
        return 'InValid Identity Number';
      }
    } else {
      return 'required';
    }
  }
}