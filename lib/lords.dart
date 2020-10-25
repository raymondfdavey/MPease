import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class LordsList extends StatefulWidget {
  @override
  _LordsState createState() => _LordsState();
}

class _LordsState extends State<LordsList> {
  final String baseUrl =
      'http://eldaddp.azurewebsites.net/lordsregisteredinterests.json';

  /// Async function called by init state root app - ultimately returns a list of Lord class instances 1 for each lord on the API.
  Future<List<Lord>> fetchLords() async {
    List<Lord> listOfLords;

    /// getPageNumbers function calculates the number of pages for the data set based on a base URl and the number of items returned per page (nax is 500)
    num numberOfPages = await getPageNumbers(baseUrl, 500);

    /// getLordsFromApi returns a list of lord Map objects decoded from the raw JSON and containing only the 'item' data we want i.e. no meta data, just each lords data
    List<Map<String, dynamic>> lordsResults = await getLordsFromApi(1);
    // await getLordsFromApi(numberOfPages);

    //converttoClass returns a list of Lord class instances, one for each lord
    listOfLords = convertToClass(lordsResults);

    listOfLords.forEach((lord) => print(lord.interests[0].interestTitle));
    // print(listOfLords[0].interests[0].interestTitle);
    return listOfLords;
  }

  Future<int> getPageNumbers(String url, int resultsPerPage) async {
    var response = await http.get(url);

    num numberOfPages;

    if (response.statusCode == 200) {
      var summary = jsonDecode(response.body);
      numberOfPages =
          (summary['result']['totalResults'] / resultsPerPage).ceil();
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

  List<Lord> convertToClass(List<Map<String, dynamic>> lordObjects) {
    List<Lord> listOfLords = [];
    for (int i = 0; i <= lordObjects.length - 1; i++) {
      Lord newLord = new Lord();
      newLord.firstName = lordObjects[i]['givenName']['_value'];
      // newLord.middleName = lordObjects[i]['additionalName']['_value'];
      newLord.surname = lordObjects[i]['familyName']['_value'];
      newLord.title = lordObjects[i]['fullName']['_value'];
      newLord.gender = lordObjects[i]['gender']['_value'];

      if (lordObjects[i]['hasRegisteredInterest'] != null) {
        newLord.interests =
            getInterests(lordObjects[i]['hasRegisteredInterest']);
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

  // Need to expand properties in class i.e. 'registeredLate'
  Interest convertToInterest(dynamic rawInterest) {
    Interest newInterest = new Interest();
    newInterest.interestTitle = rawInterest['registeredInterest']['_value'];
    newInterest.interestCategory =
        rawInterest["registeredInterestCategory"]["_value"];
    return newInterest;
  }

  Future lords;

  @override
  void initState() {
    super.initState();
    lords = fetchLords();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lord>>(
      future: lords,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${snapshot.data[index].title}'),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}

class Lord {
  String firstName;
  String middleName;
  String surname;
  String title;
  String gender;
  List<Interest> interests;
}

// Dan do:
class Interest {
  String interestTitle;
  String interestCategory;
}
