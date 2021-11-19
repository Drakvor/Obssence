class SignUpState {
  int state = 0;
  bool phoneKeyboardActiveState = false;
  bool phoneNumberError = false;

  List<bool> tnc = [false, false, false, false];

  String phoneNumber = "";
  String currentPassword = "";
  String finalisedPassword = "";
  bool showPassword = false;
}