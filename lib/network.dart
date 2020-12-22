import 'package:http/http.dart' as http;
import 'dart:convert';
import 'classes.dart';

final String baseUrlInterests =
    'http://eldaddp.azurewebsites.net/lordsregisteredinterests.json';

final String baseUrlLords =
    'http://data.parliament.uk/membersdataplatform/services/mnis/members/query/house=Lords/';

Future<Map> fetchLords() async {
  Map<String, dynamic> jsonReturnedLords;

  http.Response returnedLordsDeets = await http.get(baseUrlLords,
      headers: {"Content-Type": "application/json; charset=utf-8"});

  jsonReturnedLords = jsonDecode(returnedLordsDeets.body);
  return jsonReturnedLords;
}

Future<List<dynamic>> transformLordsToList() async {
  var extendedLordList = await fetchLords();
  List justLords = extendedLordList["Members"]["Member"];
  return justLords;
}

Future<List<Lord>> transformToLordNamesList() async {
  List lordsList = await transformLordsToList();
  List<Lord> newListofLordTitles = [];
  List<Interest> listOfInterests = [];

  lordsList.forEach((lord) {
    var isActive = lord["CurrentStatus"]["@IsActive"].toLowerCase();
    if (isActive == "true") {
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

Future<List> fetchLordsExtended() async {
  print("in fetchlords extended");
  var extendedLordList;
  List justLords;
  extendedLordList = await fetchLords();
  print("BACK IN FETCH LORDS");
  justLords = extendedLordList["Members"]["Member"];
  return justLords;
}

// Future<List<Lord>> fetchLords_OLD() async {
//   List<Lord> listOfLords;
//   /*
//   Commented out for development
//   num numberOfPages = await getPageNumbers(baseUrl, 500);
//   List<Map<String, dynamic>> lordsResults = await getLordsFromApi(numberOfPages);
// */
//   num numberOfPages = await getPageNumbers(baseUrl, 500);
//   List<Map<String, dynamic>> lordsResults =
//       await getLordsFromApi(numberOfPages);
//   // List<Map<String, dynamic>> lordsResults = await getLordsFromApi(1);
//   listOfLords = convertToClass(lordsResults);

//   return listOfLords;
// }

Future<int> getPageNumbers(String url, int resultsPerPage) async {
  var response = await http.get(url);
  num numberOfPages;
  if (response.statusCode == 200) {
    var summary = jsonDecode(response.body);
    numberOfPages = (summary['result']['totalResults'] / resultsPerPage).ceil();
  } else {
    throw Exception('failed to load summary');
  }

  return numberOfPages;
}

Future<List<Map<String, dynamic>>> getLordsFromApi(int pages) async {
  Map<String, dynamic> results = {};
  for (int i = 0; i <= pages - 1; i++) {
    String resultsKey = 'page $i';
    results[resultsKey] = await http.get(
        'http://eldaddp.azurewebsites.net/lordsregisteredinterests.json?_pageSize=500&_page=$i');
    print('done page $i');
    if (results[resultsKey].statusCode == 200) {
      continue;
    } else {
      throw Exception('Failed to load lords');
    }
  }
  List<Map<String, dynamic>> lordObjects = [];
  results.forEach((k, v) => results[k] = jsonDecode(v.body));
  results.forEach((k, v) =>
      results[k]['result']['items'].forEach((lord) => lordObjects.add(lord)));
  return lordObjects;
}
