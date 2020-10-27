import 'package:flutter/material.dart';
import 'network.dart';
import "classes.dart";

// try and impliment expansion tile whereby each lord is an expandable tile where the lords title is the title of the tile, then when you click it reveals some more details invluding an expandable interests tile where the title is registered interests and a number

class LordsList extends StatefulWidget {
  @override
  _LordsState createState() => _LordsState();
}

class _LordsState extends State<LordsList> {
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
