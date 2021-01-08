import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

int getAge(DateTime dob) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - dob.year;
  int month1 = currentDate.month;
  int month2 = dob.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = dob.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

String getYearsLording(DateTime dateStarted) {
  DateFormat formatter = DateFormat('yyyy');
  final String formatted = formatter.format(dateStarted);
  return formatted; // something like 20
}

Function checkEquality() {
  return const MapEquality().equals;
}
