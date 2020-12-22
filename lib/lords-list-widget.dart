import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';
import 'package:intl/intl.dart';

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
  // List<Lord> lords;
  // List<Lord> lordsUntouched;
  bool gotLords = false;
  // List<Map> detailsLords;
  Future someFuture;

  // Future<List<List>> getLords2() async {
  //   print("GETTING LORDS");
  //   // List<Lord> lordsFromCall = [];
  //   // List<Lord> lordsFromCall = await fetchLords_OLD();
  //   List lordsDeetsFromCall = await fetchLordsExtended();

  //   // print(lordsFromCall.length);
  //   print(lordsDeetsFromCall.length);
  //   // return [lordsFromCall, lordsDeetsFromCall];
  // }

  Future<String> getLordInfo(int memberId) async {
    // List<LordListedViewModel> newLordsList = await transformToLordNamesList();
    return memberId as Future;
  }

  Future<List<Lord>> getLordsNamesOnly() async {
    List<Lord> newLordsList = await transformToLordNamesList();
    return newLordsList;
  }

  Future<void> getLords() async {
    List<Lord> getLords = await getLordsNamesOnly();

    setState(() {
      lords = getLords;
      lordsUntouched = getLords;
      gotLords = true;
    });
  }

  void filterLords(String searchTerm) {
    print("In filter lords" + searchTerm);

    if (searchTerm == "initial text") {
      setState(() {
        lords = lordsUntouched;
      });
    } else {
      List<Lord> forFilter = lordsUntouched;
      List<Lord> filteredLords = lordsUntouched;

      filteredLords = forFilter
          .where((lord) =>
              lord.displayName.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();

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
    getLords();
  }

  @override
  Widget build(BuildContext context) {
    print("in WIDGET");
    print(widget.searchText);
    filterLords(widget.searchText); 

    return gotLords
        ? ListView.builder(
            itemCount: lords.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                //  onExpansionChanged: this.getLordInfo(index),
                  title: Text('${lords[index].displayName}'),
                  children: <Widget>[
                    Column(
                      children: [
                        // Text('${lords[index].memberId}'),
                        Text('${lords[index].displayName}'),
                        Text('Started Lording: ${lords[index].memberFrom}'),
                        Text('Party: ${lords[index].party}'),
                        Text('Born: ' + DateFormat('yyyy-MM-dd').format(lords[index].dob)),
                        Text('${lords[index]?.interests[index]?.interestTitle}')
                      ],
                    )
                  ]);
            })
        : CircularProgressIndicator();
  }
}
