import 'package:flutter/material.dart';
import 'lords-list-widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FUCKLORD by LORDCODE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('FUCKLORD'),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: LordsList()),
      ),
    );
  }
}
