import 'package:MPease/lords-expansion-1.dart';
import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';
import 'package:intl/intl.dart';

final List<int> colorCodes = <int>[600, 500, 100];

class LordsList extends StatefulWidget {
  final String searchText;
  LordsList({Key key, this.searchText}) : super(key: key);
  @override
  _LordsState createState() => _LordsState();
}

class _LordsState extends State<LordsList> {
  List<Lord> lords;
  List<Lord> lordsUntouched;
  List<Interest> interests;
  bool gotLords = false;
  Future someFuture;

  String getInterests(int memberId) {
    return "hi";
  }

  Future<List<Lord>> getLordsNamesOnly() async {
    List<Lord> newLordsList = await transformLordsToList();
    return newLordsList;
  }

  Future<void> getLords() async {
    List<Lord> getLords = await getLordsNamesOnly();

    setState(() {
      lords = getLords;
      lordsUntouched = getLords;
      gotLords = true;
      interests = [];
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

  @override
  void initState() {
    super.initState();
    getLords();
  }

  @override
  Widget build(BuildContext context) {
    filterLords(widget.searchText);

    return gotLords
        ? ListView.builder(
            itemCount: lords.length,
            itemBuilder: (context, index) {
              return LordsExpansion1(lord: lords[index]);
            })
        : CircularProgressIndicator();
  }
}
