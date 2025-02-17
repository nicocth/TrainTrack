
class Validators {

  static bool emptyfields(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }
    return true;
  }

    static bool emptyfieldsRegister(String email, String password, String confirmPassword) {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return false;
    }
    return true;
  }

  static bool validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return false;
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) {
      return false;
    }
    return true;
  }

  static bool validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return false;
    }
    if (password.length < 6) {
      return false;
    }
    return true;
  }

    static bool comparePassword(String? password, String? confirmPassword) {
    if (password != confirmPassword) {
      return false;
    }
    return true;
  }
}
