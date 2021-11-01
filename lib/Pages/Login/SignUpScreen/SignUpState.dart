class SignUpState {
  int state = 0;
  String phoneNumber = "";
  String password = "";
  String passwordConfirm = "";
  bool showPassword = false;

  void appendNumber (String number) {
    if (phoneNumber.length >= 11) {
      return;
    }
    phoneNumber = phoneNumber + number;
  }

  void subtractNumber () {
    if (phoneNumber.length == 0) {
      return;
    }
    phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
  }

  void appendPassword (String character) {
    if (password.length >= 5) {
      return;
    }
    password = password + character;
  }

  void subtractPassword () {
    if (password.length == 0) {
      return;
    }
    password = password.substring(0, password.length - 1);
  }

  void appendPasswordConfirm (String character) {
    if (passwordConfirm.length >= 5) {
      return;
    }
    passwordConfirm = passwordConfirm + character;
  }

  void subtractPasswordConfirm () {
    if (passwordConfirm.length == 0) {
      return;
    }
    passwordConfirm = passwordConfirm.substring(0, passwordConfirm.length - 1);
  }

  void togglePassword () {
    showPassword = !showPassword;
  }

  void hidePassword () {
    showPassword = false;
  }

  void nextState () {
    state++;
  }

  bool validNumber () {
    return (phoneNumber.length == 11 && phoneNumber.substring(0, 3) == "010");
  }
}