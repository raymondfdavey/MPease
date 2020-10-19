import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future fetchAlbum() async {

  final response = await http
      .get('http://eldaddp.azurewebsites.net/lordsregisteredinterests.json');

  if (response.statusCode == 200) {

    List<Map<String, dynamic>> listOfLords = [];
    Map<String, dynamic> results = {};
    var lordsSummary = jsonDecode(response.body);
    num noOfPages = lordsSummary['result']['totalResults'] / 500;
    noOfPages = noOfPages.ceil();
    for (int i = 0; i <= noOfPages - 1; i++) {
      String resultsKey = 'page $i';
      results[resultsKey] = await http.get('http://eldaddp.azurewebsites.net/lordsregisteredinterests.json?_pageSize=500&_page=$i');
      print('done page $i');
      if (results[resultsKey].statusCode == 200) {
        continue;
      } else {
        throw Exception('Failed to load lords');
      }
    }
    results.forEach((k, v) => results[k] = jsonDecode(v.body));
    results.forEach((k,v) => results[k]['result']['items'].forEach((lord) => listOfLords.add(lord)));
    listOfLords.forEach((lord) => print(lord['fullName']['_value']));
    //FAVE LORD???? MINE IS BARONESS SHACKLETON OF BELGRAVIA THOUGH THERE ARE A FEW. I THINK YOUR SPIRIT LORD IS VISCOUNT YOUNGER OF LECKIE OR MAYBE LORD PICKLES
  }
}









void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
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
        // body: Center(
        //   child: FutureBuilder<LordsAlbum>(
        //     future: futureAlbum,
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return Text(snapshot.data.name);
        //       } else if (snapshot.hasError) {
        //         return Text("${snapshot.error}");
        //       }
        //
        //       // By default, show a loading spinner.
        //       return CircularProgressIndicator();
        //     },
        //   ),
        // ),
      ),
    );
  }
}
