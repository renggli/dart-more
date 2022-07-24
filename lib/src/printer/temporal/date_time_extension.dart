extension DateTimeExtension on DateTime {
  /// The quarter `[1...4]`.
  int get quarter => 1 + (month - 1) ~/ 3;

  /// The day in the year `[1...365]`.
  int get dayInYear => 1 + difference(DateTime(year)).inDays;
}
