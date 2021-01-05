import 'package:MPease/LordTile.dart';
import 'package:MPease/utilities.dart';
import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';
import 'package:flutter/foundation.dart';

final List<int> colorCodes = <int>[600, 500, 100];

class LordsList extends StatefulWidget {
  final Map filterTerms;
  final String searchText;
  final addToFavourites;
  final removeFromFavourites;
  final bool filterOn;
  final bool searching;

  LordsList({
    Key key,
    this.filterTerms,
    this.filterOn,
    this.searchText,
    this.addToFavourites,
    this.removeFromFavourites,
    this.searching,
  }) : super(key: key);
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
  Map filterTermsDefault = {'age': 'AGE', 'party': 'PARTY', 'type': 'TYPE'};
  Future<List<Lord>> getLordsNamesOnly() async {
    List<Lord> newLordsList = await transformLordsToList();
    return newLordsList;
  }

  Map currentFilterTerms;

  Future<void> getLords() async {
    List<Lord> getLords = await getLordsNamesOnly();

    setState(() {
      lords = getLords;
      lordsUntouched = getLords;
      gotLords = true;
      interests = [];
    });
  }

  void filterOnDropdownTerms(Map filterTermsMap) {
    if (filterTermsMap["age"] != 'AGE') {
      print(filterTermsMap['age']);
    }
    if (filterTermsMap["party"] != 'PARTY') {
      print(filterTermsMap['party']);
    }
    if (filterTermsMap["type"] != 'TYPE') {
      print("FILTERING BY TYPE");
    }
  }

  void filterLords(String searchTerm) {
    List<Lord> forFilter = []..addAll(lordsUntouched);
    List<Lord> filteredLords = []..addAll(lordsUntouched);

    filteredLords = forFilter
        .where((lord) =>
            lord.displayName.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    setState(() {
      print("IN SEARCH TERM FILTER SET STATE - SEARCH TERMS");
      lords = filteredLords;
    });
  }

  @override
  void initState() {
    print("IN INIT STATE");
    super.initState();
    getLords();
  }

  @override
  Widget build(BuildContext context) {
    print("IN LORDS LIST WIDGET");
    print(widget.searching);
    print(filterTerms);
    if (widget.searching) {
      filterLords(widget.searchText);
    }

    if (!widget.searching && mapEquals(filterTermsDefault, filterTerms)) {
      setState(() {
        lords = lordsUntouched;
      });
    }

    if (!mapEquals(filterTermsDefault, filterTerms)) {
      filterOnDropdownTerms(filterTerms);
    }

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
