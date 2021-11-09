class ReservationState {
  int state = 0;
  int date = 0;
  int time = 0;
  String location = "";

  void nextState () {
    state++;
  }

  void setDate (int data) {
    date = data;
  }

  void reset () {
    state = 0;
    date = 0;
    time = 0;
    location = "";
  }
}