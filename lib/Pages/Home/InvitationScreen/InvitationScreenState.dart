class InvitationScreenState {
  String phoneNumber = "";

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

  void setNumber (String number) {
    phoneNumber = number;
  }
}