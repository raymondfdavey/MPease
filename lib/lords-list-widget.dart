import 'package:MPease/LordTile.dart';
import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';

final List<int> colorCodes = <int>[600, 500, 100];

class LordsList extends StatefulWidget {
  final Map filterTerms;
  final String searchText;
  final addToFavourites;
  final removeFromFavourites;
  final bool filterOn;
  LordsList(
      {Key key,
      this.filterTerms,
      this.filterOn,
      this.searchText,
      this.addToFavourites,
      this.removeFromFavourites})
      : super(key: key);
  @override
  _LordsState createState() => _LordsState(
      filterTerms, filterOn, addToFavourites, removeFromFavourites, searchText);
}

class _LordsState extends State<LordsList> {
  final Map filterTerms;
  final String searchText;
  List<Lord> lords;
  List<Lord> lordsUntouched;
  Function addToFavourites;
  Function removeFromFavourites;
  bool filterOn;
  List<Interest> interests;
  bool gotLords = false;
  Future someFuture;
  _LordsState(this.filterTerms, this.filterOn, this.addToFavourites,
      this.removeFromFavourites, this.searchText);

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
              return LordTile(
                lord: lords[index],
                addToFavourites: addToFavourites,
                removeFromFavourites: removeFromFavourites,
              );
            })
        : CircularProgressIndicator();
  }
}
