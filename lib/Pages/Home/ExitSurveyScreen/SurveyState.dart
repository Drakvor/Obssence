class SurveyState {
  List<String> reason = [];

  void addReason (String data ) {
    reason.add(data);
  }

  void removeReason (String data) {
    reason.remove(data);
  }
}