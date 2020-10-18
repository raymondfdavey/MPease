import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future fetchAlbum() async {
  Map<String, dynamic> results = {};
  final response = await http
      .get('http://eldaddp.azurewebsites.net/lordsregisteredinterests.json');

  if (response.statusCode == 200) {
    var lordsSummary = jsonDecode(response.body);
    num noOfPages = lordsSummary['result']['totalResults'] / 500;
    noOfPages = noOfPages.ceil();

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
  }


  /*CODE FOR GETTING at the bits we want, creating classes from it and whatnot, here. currently object is
  {page1: {format: "format": "linked-data-api",
  "version": "0.2",
  "result": {
  "_about": "http://eldaddp.azurewebsites.net/lordsregisteredinterests.json",
  "definition": "http://eldaddp.azurewebsites.net/meta/lordsregisteredinterests.json",
  "extendedMetadataVersion": "http://eldaddp.azurewebsites.net/lordsregisteredinterests.json?_metadata=all",
  "first": "http://eldaddp.azurewebsites.net/lordsregisteredinterests.json?_page=0",
  "hasPart": "http://eldaddp.azurewebsites.net/lordsregisteredinterests.json",
  "isPartOf": "http://eldaddp.azurewebsites.net/lordsregisteredinterests.json",
  "items": [
{
  "_about": "http://data.parliament.uk/members/100",
  "additionalName": {
  "_value": "Gavin"
  */
   
}




// class LordsAlbum {
//   final Map items;
//   LordsAlbum({this.items});

//   factory LordsAlbum.fromJson(Map<String, dynamic> json) {
//     return LordsAlbum(
//       items: json['items']
//     );
//   }.
//   String toString() {
//    return '$items';
//   }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<LordsAlbum> futureAlbum;

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
