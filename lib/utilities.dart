import 'classes.dart';

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

String getId(String url) {
  String aStr;
  aStr = url.replaceAll(new RegExp(r'[^0-9]'), "");
  return aStr;
}

List<Lord> convertToClass(List<Map<String, dynamic>> lordObjects) {
  List<Lord> listOfLords = [];
  for (int i = 0; i <= lordObjects.length - 1; i++) {
    Lord newLord = new Lord();
    newLord.firstName = lordObjects[i]['givenName']['_value'];
    newLord.surname = lordObjects[i]['familyName']['_value'];
    newLord.title = lordObjects[i]['fullName']['_value'];
    newLord.gender = lordObjects[i]['gender']['_value'];
    newLord.id = getId(lordObjects[i]["_about"]);

    if (lordObjects[i]['hasRegisteredInterest'] != null) {
      newLord.interests = getInterests(lordObjects[i]['hasRegisteredInterest']);
    }
    listOfLords.add(newLord);
  }
  return listOfLords;
}

List<Interest> getInterests(dynamic rawInterests) {
  List<Interest> listOfInterests = [];
  if (rawInterests is List && rawInterests.length > 1) {
    rawInterests.forEach((interest) {
      listOfInterests.add(convertToInterest(interest));
    });
  } else {
    Interest newInterest = convertToInterest(rawInterests);
    listOfInterests.add(newInterest);
  }
  return listOfInterests;
}

Interest convertToInterest(dynamic rawInterest) {
  Interest newInterest = new Interest();
  newInterest.interestTitle = rawInterest['registeredInterest']['_value'];
  newInterest.interestCategory =
      rawInterest["registeredInterestCategory"]["_value"];
  return newInterest;
}
