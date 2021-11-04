class LoginState {
  int state = 0;
  bool phoneKeyboardActiveState = false;
  bool phoneNumberError = false;

  String phoneNumber = "";
  String password = "";
  bool showPassword = false;
}