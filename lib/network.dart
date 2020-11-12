import 'package:http/http.dart' as http;
import 'dart:convert';
import 'classes.dart';
import 'utilities.dart';

final String baseUrl =
    'http://eldaddp.azurewebsites.net/lordsregisteredinterests.json';

// Future<Response> fetchLordsLongList() async {
//   Future<Response> result;

//   result = await http.get(
//       'http://data.parliament.uk/membersdataplatform/services/mnis/members/query/house=Lords/');

//   return result;
// }
Future<Map> getLordsExtendedFromApi() async {
  print("IN GETLORDS FROM API");
  http.Response returnedLordsDeets;
  Map<String, dynamic> jsonReturnedLords;
  returnedLordsDeets = await http.get(
      'http://data.parliament.uk/membersdataplatform/services/mnis/members/query/house=Lords/',
      headers: {"Content-Type": "application/json; charset=utf-8"});
  print("GOT LORDS DEETS");
  jsonReturnedLords = jsonDecode(returnedLordsDeets.body);

  return jsonReturnedLords;
}

Future<List> fetchLordsExtended() async {
  print("in fetchlords extended");
  var extendedLordList;
  List justLords;
  extendedLordList = await getLordsExtendedFromApi();
  print("BACK IN FETCH LORDS");
  justLords = extendedLordList["Members"]["Member"];
  return justLords;
}

Future<List<Lord>> fetchLords() async {
  List<Lord> listOfLords;
  /*
  Commented out for development
  num numberOfPages = await getPageNumbers(baseUrl, 500);
  List<Map<String, dynamic>> lordsResults = await getLordsFromApi(numberOfPages);
*/
  num numberOfPages = await getPageNumbers(baseUrl, 500);
  List<Map<String, dynamic>> lordsResults =
      await getLordsFromApi(numberOfPages);
  // List<Map<String, dynamic>> lordsResults = await getLordsFromApi(1);
  listOfLords = convertToClass(lordsResults);

  return listOfLords;
}

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
    // results[resultsKey] = await http.get(
    //     'http://eldaddp.azurewebsites.net/lordsregisteredinterests.json?_pageSize=500&_page=$i');
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
