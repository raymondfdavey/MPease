import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<LordsAlbum> fetchAlbum() async {

  final response = await http
      .get('http://eldaddp.azurewebsites.net/lordsregisteredinterests.json?_pageSize=10&_page=0');

  if (response.statusCode == 200) {

  var lordsItemsJson = LordsAlbum.fromJson(jsonDecode(response.body));
  print(lordsItemsJson);

    }
   else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}



class LordsAlbum {
  final Map items;
  LordsAlbum({this.items});

  factory LordsAlbum.fromJson(Map<String, dynamic> json) {
    return LordsAlbum(
      items: json['items']
    );
  }.
  String toString() {
   return '$items';
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
