String getDate(String date) {
  String year = date.substring(0, 4);
  String month = date.substring(5, 7);
  String day = date.substring(8, 10);

  String formattedDate = "$day/$month/$year";
  return formattedDate;
}

String getYears(String age) {
  var targetDateObj = DateTime.parse(age);
  var now = new DateTime.now();
  var difference = now.difference(targetDateObj).inDays;

  return (difference / 365).floor().toString();
}
