import 'package:MPease/LordTile.dart';
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
  final fakeSetState;
  final List<Lord> favouriteLordsList;

  LordsList({
    Key key,
    this.filterTerms,
    this.filterOn,
    this.searchText,
    this.addToFavourites,
    this.removeFromFavourites,
    this.searching,
    this.fakeSetState,
    this.favouriteLordsList,
  }) : super(key: key);
  @override
  _LordsState createState() => _LordsState(filterTerms, filterOn,
      addToFavourites, removeFromFavourites, searchText, fakeSetState);
}

class _LordsState extends State<LordsList> {
  final Map filterTerms;
  final String searchText;
  List<Lord> lords;
  List<Lord> lordsUntouched;
  Function fakeSetState;
  Function addToFavourites;
  Function removeFromFavourites;
  bool filterOn;
  List<Interest> interests;
  bool gotLords = false;
  Future someFuture;
  _LordsState(this.filterTerms, this.filterOn, this.addToFavourites,
      this.removeFromFavourites, this.searchText, this.fakeSetState);
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

  List<Lord> filterOnDropdownTerms(Map filterTermsMap) {
    List<Lord> forFilterHere = []..addAll(lordsUntouched);
    List<Lord> filteredLordsHere = []..addAll(lordsUntouched);
    if (filterTermsMap["age"] != 'AGE') {
      if (filterTermsMap["age"] == '< 50') {
        filteredLordsHere =
            forFilterHere.where((lord) => lord.dob < 50).toList();
      }
      if (filterTermsMap["age"] == '50 - 60') {
        filteredLordsHere = forFilterHere
            .where((lord) => lord.dob >= 50 && lord.dob < 60)
            .toList();
      }
      if (filterTermsMap["age"] == '60-70') {
        filteredLordsHere = forFilterHere
            .where((lord) => lord.dob >= 60 && lord.dob < 70)
            .toList();
      }
      if (filterTermsMap["age"] == '70-80') {
        filteredLordsHere = forFilterHere
            .where((lord) => lord.dob >= 70 && lord.dob < 80)
            .toList();
      }
      if (filterTermsMap["age"] == '80-90') {
        filteredLordsHere = forFilterHere
            .where((lord) => lord.dob >= 80 && lord.dob < 90)
            .toList();
      }
      if (filterTermsMap["age"] == '90+') {
        filteredLordsHere =
            forFilterHere.where((lord) => lord.dob >= 90).toList();
      }
    }
    if (filterTermsMap["party"] != 'PARTY') {
      if (filterTermsMap['party'] == 'Other') {
        filteredLordsHere = filteredLordsHere != null
            ? filteredLordsHere
                .where((lord) =>
                    lord.party.contains("Independent") ||
                    lord.party.contains("Speaker"))
                .toList()
            : forFilterHere
                .where((lord) =>
                    lord.party.contains("Independent") ||
                    lord.party.contains("Speaker"))
                .toList();
      } else {
        filteredLordsHere = filteredLordsHere != null
            ? filteredLordsHere
                .where((lord) => lord.party.contains(filterTermsMap['party']))
                .toList()
            : forFilterHere
                .where((lord) => lord.party.contains(filterTermsMap['party']))
                .toList();
      }
    }
    if (filterTermsMap["type"] != 'TYPE') {
      filteredLordsHere = filteredLordsHere != null
          ? filteredLordsHere
              .where((lord) => lord.memberFrom
                  .toLowerCase()
                  .contains(filterTermsMap["type"].toLowerCase()))
              .toList()
          : forFilterHere
              .where((lord) => lord.memberFrom
                  .toLowerCase()
                  .contains(filterTermsMap["type"].toLowerCase()))
              .toList();
    }
    return filteredLordsHere;
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
    if (widget.searching) {
      filterLords(widget.searchText);
    }
    if (!widget.searching && mapEquals(filterTermsDefault, filterTerms)) {
      setState(() {
        print("in resetting lords set state");
        lords = lordsUntouched;
      });
    }
    if (!mapEquals(filterTermsDefault, widget.filterTerms)) {
      List<Lord> ans;
      ans = filterOnDropdownTerms(widget.filterTerms);
      setState(() {
        print("IN FILTERING SET STATE");
        lords = ans;
        currentFilterTerms = widget.filterTerms;
      });
    }
    return gotLords
        ? ListView.builder(
            key: UniqueKey(),
            itemCount: lords.length,
            itemBuilder: (context, index) {
              return LordTile(
                favouriteLordsList: widget.favouriteLordsList,
                lord: this.lords[index],
                addToFavourites: addToFavourites,
                removeFromFavourites: removeFromFavourites,
              );
            })
        : CircularProgressIndicator();
  }
}
