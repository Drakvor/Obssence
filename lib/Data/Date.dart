class MonthData {
  Map<int, DayData> calendar;
  int month;
  int year;
  MonthData(this.year, this.month, this.calendar);
}

class DayData {
  String type;
  int dayName;
  int day;
  List<String> times;
  DayData({required this.day, required this.dayName, required this.times, required this.type});
}