import 'package:MPease/LordListBuilder.dart';
import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';
import "utilities.dart";

final List<int> colorCodes = <int>[600, 500, 100];

// try and impliment expansion tile whereby each lord is an expandable tile where the lords title is the title of the tile, then when you click it reveals some more details invluding an expandable interests tile where the title is registered interests and a number
class LordsList extends StatefulWidget {
  final bool saved;
  final String searchText;
  final savedToggle;
  LordsList({Key key, this.searchText, this.saved, this.savedToggle})
      : super(key: key);
  @override
  _LordsState createState() => _LordsState();
}

class _LordsState extends State<LordsList> {
  List<Lord> lords;
  List<Lord> lordsUntouched;
  bool gotLords = false;
  List<String> favourites;
  final faveLords = Set<Lord>();
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
          // print('IN FOR EACH START'),
          // print(lordInstance.title),
          // print(lordInstance.id),
          match = lordsDeetsFromCall
              .where((lordMap) => lordMap["@Member_Id"] == lordInstance.id)
              .toList(),
          if (match.length == 0)
            {i++, idsToDelete.add(lordInstance.id)}
          else
            {
              // print(match[0]["Gender"]),
              // print(match.runtimeType),
              // print("in matches"),ß
              // // print(match["Gender"]),
              // // print(match["DateOfBirth"]),
              // // print(match["Party"]["#text"]),
              // // print(match["MemberFrom"]),
              // // print(match["HouseStartDate"]),
              // // print(match["CurrentStatus"]["@IsActive"]),
              j++,
              lordInstance.gender = match[0]["Gender"],
              lordInstance.dob = match[0]["DateOfBirth"],
              lordInstance.dobFormatted = getDate(match[0]["DateOfBirth"]),
              lordInstance.age = getYears(match[0]["DateOfBirth"]),
              lordInstance.party = match[0]["Party"]["#text"],
              lordInstance.peerageType = match[0]["MemberFrom"],
              lordInstance.beganLording = match[0]["HouseStartDate"],
              lordInstance.beganLordingInYears =
                  getYears(match[0]["HouseStartDate"]),
              lordInstance.beganLordingFormatted =
                  getDate(match[0]["HouseStartDate"]),
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
              lord.title.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();

      setState(() {
        lords = filteredLords;
      });
    }
  }

  void pushSavedLords() async {
    print("PUSHING LORDS");
    print(faveLords);
    Future.delayed(Duration.zero, () {
      Navigator.of(context).push(
        MaterialPageRoute(
          // NEW lines from here...
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      widget.savedToggle();
                      Navigator.of(context).pop();
                    }),
                title: Text('Saved Suggestions'),
              ),
              body: LordsListBuilder(faveLords.toList()),
            );
          }, // ...to here.
        ),
      );
    });
  }

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
    if (widget.saved == true) {
      pushSavedLords();
    }

    return gotLords
        ? ListView.builder(
            itemCount: lords.length,
            itemBuilder: (context, index) {
              final alreadySaved = faveLords.contains(lords[index]);
              return ExpansionTile(
                  title: Text('${lords[index].title}'),
                  leading: IconButton(
                      icon: alreadySaved
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                      color: alreadySaved ? Colors.red : null,
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            faveLords.remove(lords[index]);
                          } else {
                            faveLords.add(lords[index]);
                          }
                        });
                      }),
                  children: <Widget>[
                    Column(
                      children: [
                        Text('${lords[index].firstName}'),
                        Text('${lords[index].surname}'),
                        Text('${lords[index].gender}'),
                        Text('dob: ${lords[index].dobFormatted}'),
                        Text('age: ${lords[index].age}'),
                        Text('${lords[index].party}'),
                        Text('${lords[index].peerageType}'),
                        Text('isActive: ${lords[index].isActive}'),
                        Text(
                            'started lording: ${lords[index].beganLordingFormatted}'),
                        Text(
                            'years lording: ${lords[index].beganLordingInYears}'),
                        ExpansionTile(
                            title: Text('Registered Interests'),
                            children: <Widget>[
                              Text("HI HI HI"),
                              Text(
                                  '${lords[index].interests[0].interestCategory}'),
                              SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: lords[index].interests.length,
                                      itemBuilder: (BuildContext ctx, int i) {
                                        return new Text(
                                            '${lords[index].interests[i].interestTitle}');
                                      }))
                            ])
                      ],
                    )
                  ]);
            })
        : CircularProgressIndicator();
  }
}
