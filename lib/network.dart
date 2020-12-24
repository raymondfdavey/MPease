import 'package:http/http.dart' as http;
import 'dart:convert';
import 'classes.dart';

final String baseUrlInterests =
    'http://eldaddp.azurewebsites.net/lordsregisteredinterests.json';
final String baseUrlLords =
    'http://data.parliament.uk/membersdataplatform/services/mnis/members/query/house=Lords/';
final String baseUrlMembersAPI = 'https://members-api.parliament.uk/api/';

String getUrlLordInfoById(int memberId) {
  return baseUrlMembersAPI + 'Members/' + memberId.toString();
}

String getUrlLordInterestById(int memberId) {
  return baseUrlMembersAPI +
      'Members/' +
      memberId.toString() +
      '/RegisteredInterests';
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
      Lord newLordListedItem = new Lord();
      newLordListedItem.memberId = int.parse(lord["@Member_Id"]);
      newLordListedItem.displayName = lord["DisplayAs"];
      newLordListedItem.memberFrom = lord["MemberFrom"];
      newLordListedItem.party = lord["Party"]["#text"];
      newLordListedItem.dob = DateTime.parse(lord["DateOfBirth"]);
      newLordListedItem.interests = listOfInterests;
      
      newListofLordTitles.add(newLordListedItem);
    }
  });
  return newListofLordTitles;
}
