class LoginState {
  int state = 0;
  String phoneNumber = "";
  String password = "";
  bool showPassword = false;

  void appendToPhoneNumber (String number) {
    phoneNumber = phoneNumber + number;
  }

  void subtractFromPhoneNumber () {
    phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
  }

  void appendToPassword (String character) {
    password = password + character;
  }

  void subtractFromPassword () {
    password = password.substring(0, password.length - 1);
  }

  void toggleShowPassword () {
    showPassword = !showPassword;
  }

  void nextState () {
    state++;
  }
}