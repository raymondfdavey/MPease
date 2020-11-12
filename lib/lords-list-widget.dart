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
  List<Lord> lords;
  List<Lord> lordsUntouched;
  bool gotLords = false;
  // List<Map> detailsLords;
  Future someFuture;

  Future<List<List>> getLords2() async {
    print("GETTING LORDS");
    List<Lord> lordsFromCall = await fetchLords();
    List lordsDeetsFromCall = await fetchLordsExtended();
    print(lordsFromCall.length);
    print(lordsDeetsFromCall.length);
    return [lordsFromCall, lordsDeetsFromCall];
  }

  Future<void> getLords() async {
    print('WAITING ON LORDS');
    List<List> twoReturns = await getLords2();

    print("GOT LORDS");
    List<Lord> lordsFromCall = twoReturns[0];
    List lordsDeetsFromCall = twoReturns[1];
    List idsToDelete = [];
    print(lordsFromCall.length);
    print(lordsDeetsFromCall.length);
    List match;
    int i = 0;
    int j = 0;
    lordsFromCall.forEach((lordInstance) => {
          print('IN FOR EACH START'),
          // print(lordInstance.title),
          // print(lordInstance.id),
          match = lordsDeetsFromCall
              .where((lordMap) => lordMap["@Member_Id"] == lordInstance.id)
              .toList(),
          if (match.length == 0)
            {print("in zero matches"), i++, idsToDelete.add(lordInstance.id)}
          else
            {
              // print(match[0]["Gender"]),
              // print(match.runtimeType),
              // print("in matches"),
              // // print(match["Gender"]),
              // // print(match["DateOfBirth"]),
              // // print(match["Party"]["#text"]),
              // // print(match["MemberFrom"]),
              // // print(match["HouseStartDate"]),
              // // print(match["CurrentStatus"]["@IsActive"]),
              j++,
              lordInstance.gender = match[0]["Gender"],
              lordInstance.dob = match[0]["DateOfBirth"],
              lordInstance.party = match[0]["Party"]["#text"],
              lordInstance.peerageType = match[0]["MemberFrom"],
              lordInstance.beganLording = match[0]["HouseStartDate"],
              lordInstance.isActive = match[0]["CurrentStatus"]["@IsActive"],
            }
        });
    print("BEFORE DELETE");
    print(lordsFromCall.length);
    idsToDelete
        .forEach((id) => lordsFromCall.removeWhere((lord) => lord.id == id));
    print("AFTER DELETE");
    print(lordsFromCall.length);
    print(lordsFromCall[0].dob);

    setState(() {
      lords = lordsFromCall;
      lordsUntouched = lordsFromCall;
      gotLords = true;
    });
  }

  // void filterLords(String searchTerm) {
  //   print("In filter lords" + searchTerm);

  //   if (searchTerm == "initial text") {
  //     setState(() {
  //       lords = lordsUntouched;
  //     });
  //   } else {
  //     List<Lord> forFilter = lordsUntouched;
  //     List<Lord> filteredLords = lordsUntouched;

  //     filteredLords = forFilter
  //         .where((lord) =>
  //             lord.title.toLowerCase().contains(searchTerm.toLowerCase()))
  //         .toList();

  //     setState(() {
  //       lords = filteredLords;
  //     });
  //   }
  // }

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
    getLords();
  }

  @override
  Widget build(BuildContext context) {
    print("in WIDGET");
    print(widget.searchText);
    // filterLords(widget.searchText);

    return FutureBuilder<List<Lord>>(
      future: someFuture,
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
