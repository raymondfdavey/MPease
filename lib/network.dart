import 'package:http/http.dart' as http;
import 'dart:convert';
import 'classes.dart';

final String baseUrlInterests =
    'http://eldaddp.azurewebsites.net/lordsregisteredinterests.json';
final String baseUrlLords =
    'http://data.parliament.uk/membersdataplatform/services/mnis/members/query/house=Lords/';
final String baseUrlMembersAPI = 'https://members-api.parliament.uk/api/';

// Future<String> getLordsPictureUrl(int memberId) async {
//   print("IN HEREEEE");
//   String callUrl =
//       baseUrlMembersAPI + 'Members/' + memberId.toString() + '/PortraitUrl';
//   print(callUrl);
//   http.Response pictureUrl = await http.get(
//       baseUrlMembersAPI + 'Members/' + memberId.toString() + '/PortraitUrl');
//   String stringifiedUrl = jsonDecode(pictureUrl.body);
//   print(stringifiedUrl);
//   return stringifiedUrl;
// }

// String fetchLordsPictureUrl(int memberId) {
//   Future<String> decodedResponse = getLordsPictureUrl(memberId);
//   print(decodedResponse);
// }

String getUrlLordInfoById(int memberId) {
  return baseUrlMembersAPI + 'Members/' + memberId.toString();
}

String getUrlLordInterestById(int memberId) {
  return baseUrlMembersAPI +
      'Members/' +
      memberId.toString() +
      '/RegisteredInterests';
}

Future<List> getRegisteredInterests(String url) async {
  http.Response callForInterests = await http.get(url);
  print(callForInterests.statusCode);
  if (callForInterests.statusCode != 200) return [];
  Map<String, dynamic> jsonReturnedInterests =
      jsonDecode(callForInterests.body);

  List stuff = jsonReturnedInterests["value"];
  return stuff;
}

Future<List<Interest>> fetchInterestsById(id) async {
  List<Interest> interests;
  String url = getUrlLordInterestById(id);
  List interestsJson = await getRegisteredInterests(url);
  interests = convertToInterestList(interestsJson);

  return interests;
}

List<Interest> convertToInterestList(List interestsJson) {
  List<Interest> interests = [];
  for (var i = 0; i < interestsJson.length; i++) {
    for (var j = 0; j < interestsJson[i]["interests"].length; j++) {
      Interest newOne = new Interest();
      newOne.interestCategory = interestsJson[i]["name"];
      newOne.interestTitle = interestsJson[i]["interests"][j]["interest"];
      newOne.started = interestsJson[i]["interests"][j]["createdWhen"];
      interests.add(newOne);
    }
  }
  print(interests);
  return interests;
}

Future<bool> attemptPictureUrl(String url) async {
  http.Response callToUrl = await http.get(url);

  if (callToUrl.statusCode == 200)
    return true;
  else
    return false;
}

Future<Map> fetchLordsFromAPI() async {
  Map<String, dynamic> jsonReturnedLords;

  http.Response returnedLordsDeets = await http.get(baseUrlLords,
      headers: {"Content-Type": "application/json; charset=utf-8"});

  jsonReturnedLords = jsonDecode(returnedLordsDeets.body);
  return jsonReturnedLords;
}

bool isLordActive(dynamic lord) {
  var isActive = lord["CurrentStatus"]["@IsActive"].toLowerCase();
  return isActive == "true";
}

Future<List<Lord>> transformLordsToList() async {
  var extendedLordList = await fetchLordsFromAPI();
  List lordsList = extendedLordList["Members"]["Member"];
  List<Lord> newListofLordTitles = [];
  List<Interest> listOfInterests = [];

  lordsList.forEach((lord) {
    if (isLordActive(lord)) {
      String memberId = lord["@Member_Id"].toString();
      Lord newLordListedItem = new Lord();
      newLordListedItem.memberId = int.parse(lord["@Member_Id"]);
      newLordListedItem.displayName = lord["DisplayAs"];
      newLordListedItem.memberFrom = lord["MemberFrom"];
      newLordListedItem.party = lord["Party"]["#text"];
      newLordListedItem.gender = lord["Gender"];
      newLordListedItem.dob = DateTime.parse(lord["DateOfBirth"]);
      newLordListedItem.interests = listOfInterests;
      newLordListedItem.startedLording = DateTime.parse(lord["HouseStartDate"]);
      newLordListedItem.pictureUrl =
          'https://members-api.parliament.uk/api/Members/' +
              '$memberId' +
              '/Portrait?cropType=oneone';
      newListofLordTitles.add(newLordListedItem);
    }
  });
  return newListofLordTitles;
}
