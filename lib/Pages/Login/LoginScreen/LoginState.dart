import 'package:luxury_app_pre/Pages/Login/LoginScreen/Keyboards.dart';

class LoginState {
  int state = 0;
  String phoneNumber = "";
  String password = "";
  bool showPassword = false;
  List<bool> phoneButtonPressed = List.filled(Keyboards.phoneNumberKeys.length, false);

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

  void togglePhoneButton (int index) {
    phoneButtonPressed[index] = !phoneButtonPressed[index];
  }

  void nextState () {
    state++;
  }
}