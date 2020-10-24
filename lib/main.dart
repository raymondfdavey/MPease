import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final String baseUrl =
    'http://eldaddp.azurewebsites.net/lordsregisteredinterests.json';

// Ray do:
// fetchLords to show ALL Lords, so make a new function that
// 1. gets how many pages,
// 2. function that returns all Encoded Lords (has arguement = page number)

Future<List<Lord>> fetchLords(int page) async {
  var response = await http.get(baseUrl); // + page.toString() when needed
  List<Lord> listOfLords = [];
  num numberOfPages;

  if (response.statusCode == 200) {
    var lordsSummary = jsonDecode(response.body);
    numberOfPages = (lordsSummary['result']['totalResults'] / 500).ceil();
    Map<String, dynamic> results = {};

    for (int i = 0; i <= numberOfPages - 1; i++) {
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
    List lordObjects = [];

    results.forEach((k, v) => results[k] = jsonDecode(v.body));
    results.forEach((k, v) =>
        results[k]['result']['items'].forEach((lord) => lordObjects.add(lord)));

    for (int i = 0; i <= lordObjects.length - 1; i++) {
      Lord newLord = new Lord();
      newLord.name = lordObjects[i]['fullName']['_value'];
      listOfLords.add(newLord);
    }
  } else {
    throw Exception('Failed to load lords');
  }
  print(listOfLords[0].name);
  return listOfLords;
}

// Future fetchAlbum() async {
//   final response = await http
//       .get('http://eldaddp.azurewebsites.net/lordsregisteredinterests.json');

//   if (response.statusCode == 200) {
//     List<Lord> newListOfLords = new List<Lord>();
//     List<Map<String, dynamic>> listOfLords = [];
//     Map<String, dynamic> results = {};
//     Map<String, dynamic> results2 = {};
//     var lordsSummary = jsonDecode(response.body);
//     num noOfPages = lordsSummary['result']['totalResults'] / 500;
//     noOfPages = noOfPages.ceil();

//     for (int i = 0; i <= noOfPages - 1; i++) {
//       String resultsKey = 'page $i';
//       results[resultsKey] = await http.get(
//           'http://eldaddp.azurewebsites.net/lordsregisteredinterests.json?_pageSize=500&_page=$i');
//       print('done page $i');
//       if (results[resultsKey].statusCode == 200) {
//         continue;
//       } else {
//         throw Exception('Failed to load lords');
//       }
//     }

//     results.forEach((k, v) => results[k] = jsonDecode(v.body));

//     results.forEach((k, v) =>
//         results[k]['result']['items'].forEach((lord) => listOfLords.add(lord)));

//     for (int i = 0; i <= listOfLords.length - 1; i++) {
//       Lord newLord = new Lord();
//       newLord.name = listOfLords[i]['fullName']['_value'];
//       newListOfLords.add(newLord);
//     }

//     print(newListOfLords[0].name);
//     print(newListOfLords[1].name);
//     print(newListOfLords);

//     //FAVE LORD???? MINE IS BARONESS SHACKLETON OF BELGRAVIA THOUGH THERE ARE A FEW. I THINK YOUR SPIRIT LORD IS VISCOUNT YOUNGER OF LECKIE OR MAYBE LORD PICKLES
//   }
// }

class Lord {
  String name;
  // String posh name?
  // String ADDITIONAL name?
  // String FAMILY name?
  // List<Interest> interests
}

// Dan do:
// class Interest {
// string interstTitle
//}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future futureAlbum;
  Future lords;

  @override
  void initState() {
    super.initState();
    // futureAlbum = fetchAlbum();
    lords = fetchLords(0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Lord>>(
            future: lords,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${snapshot.data[index].name}'),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              print(snapshot);

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

/*

   
 List<Lord> newListOfLords = new List<Lord>();
    List<Map<String, dynamic>> listOfLords = [];
    Map<String, dynamic> results = {};
    Map<String, dynamic> results2 = {};
    for (int i = 0; i <= noOfPages - 1; i++) {
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

    results.forEach((k, v) => results[k] = jsonDecode(v.body));

    results.forEach((k, v) =>
        results[k]['result']['items'].forEach((lord) => listOfLords.add(lord)));

    for (int i = 0; i <= listOfLords.length - 1; i++) {
      Lord newLord = new Lord();
      newLord.name = listOfLords[i]['fullName']['_value'];
      newListOfLords.add(newLord);
    }

    print(newListOfLords[0].name);
    print(newListOfLords[1].name);
    print(newListOfLords);

    //FAVE LORD???? MINE IS BARONESS SHACKLETON OF BELGRAVIA THOUGH THERE ARE A FEW. I THINK YOUR SPIRIT LORD IS VISCOUNT YOUNGER OF LECKIE OR MAYBE LORD PICKLES
  }

    if (response.statusCode == 200) {
    final dynamic result = response.body;
    List decodedList = jsonDecode(result)['result']['items'];

    for (int i = 0; i <= decodedList.length - 1; i++) {
      Lord newLord = new Lord();
      newLord.name = decodedList[i]['fullName']['_value'];
      listOfLords.add(newLord);
    }
  } else {
    throw Exception('Failed to load lords');
  }

*/
