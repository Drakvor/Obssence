class ReservationState {
  int state = 0;
  int date = 0;
  String month = "10월";
  int time = 0;
  String location = "";

  void nextState () {
    state++;
  }

  void setDate (int data) {
    date = data;
  }

  void setTime (int data) {
    time = data;
  }


  void reset () {
    state = 0;
    date = 0;
    time = 0;
    location = "";
  }
}