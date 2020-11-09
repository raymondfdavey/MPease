import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';

final List<int> colorCodes = <int>[600, 500, 100];

// try and impliment expansion tile whereby each lord is an expandable tile where the lords title is the title of the tile, then when you click it reveals some more details invluding an expandable interests tile where the title is registered interests and a number
class LordsList extends StatefulWidget {
  final String searchText;
  LordsList({Key key, this.searchText}) : super(key: key);
  @override
  _LordsState createState() => _LordsState();
}

class _LordsState extends State<LordsList> {
  Future<List<Lord>> lordsUntouched;
  Future<List<Lord>> lords;
  List<Lord> copyOfLords;

  void filterLords(String searchTerm) {
    print("In filter lords" + searchTerm);

    if (searchTerm == "initial text") {
      setState(() {
        lords = lordsUntouched;
      });
    } else {
      Future<List<Lord>> forFilter = lordsUntouched;
      Future<List<Lord>> filteredLords = lordsUntouched;

      filteredLords = Future.wait([forFilter]).then((results) => results[0]
          .where((lord) =>
              lord.title.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList());

      setState(() {
        lords = filteredLords;
      });
    }
  }

  //   /*
  // Future.wait([fetchLords()])
  //       .then((List<List<Lord>> results) => copyOfLords = results[0]);
  //   */
  //   print("In filter lords" + searchTerm);
  //   // List<Lord> filteredLords =
  //   //     lordList.where((lord) => lord.surname.contains(searchTerm)).toList();
  //   // print(filteredLords.length);
  //   // return filteredLords;
  // }
  @override
  void initState() {
    super.initState();
    lords = fetchLords();
    lordsUntouched = lords;
  }

  @override
  Widget build(BuildContext context) {
    print("in WIDGET");
    print(widget.searchText);
    filterLords(widget.searchText);

    return FutureBuilder<List<Lord>>(
      future: lords,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                    title: Text('${snapshot.data[index].title}'),
                    children: <Widget>[
                      Column(
                        children: [
                          Text('${snapshot.data[index].firstName}'),
                          Text('${snapshot.data[index].surname}'),
                          Text('${snapshot.data[index].gender}'),
                          ExpansionTile(
                              title: Text('Registered Interests'),
                              children: <Widget>[
                                Text("HI HI HI"),
                                Text(
                                    '${snapshot.data[index].interests[0].interestCategory}'),
                                SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot
                                            .data[index].interests.length,
                                        itemBuilder: (BuildContext ctx, int i) {
                                          return new Text(
                                              '${snapshot.data[index].interests[i].interestTitle}');
                                        }))
                              ])
                        ],
                      )
                    ]);
              });
        }
        // Text(
        //     '${snapshot.data[index].interests[0].interestTitle}'),
        // Text(
        //     '${snapshot.data[index].interests[0].interestCategory}'),

        //   height: 50,
        //   color: Colors.amber[colorCodes[i]],
        //   child: Column(children: [
        //     Text(
        //         ' ${snapshot.data[index].interests[i].interestTitle}'),
        //     Text(
        //         ' ${snapshot.data[index].interests[i].interestTitle}'),
        //   ]),
        // );
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}