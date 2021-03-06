import 'package:MPease/favouritesScreen.dart';
import 'package:flutter/material.dart';
import 'lords-list-widget.dart';
import "classes.dart";
import "aboutPage.dart";
import "visualsPage.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("F LORDS");

  FocusNode myFocusNode;
  String searchText = "";
  List<Lord> favouriteLordsList = [];
  bool toggleThatDoesNothing = false;
  bool searching = false;
  bool filterOn = false;
  Map filterTerms = {'age': 'AGE', 'party': 'PARTY', 'type': 'TYPE'};

  void handleFilterSelection(String value) {
    print("HANDLING FILTER SELCTION AND SETTING STATE");
    if (value.startsWith("AGE")) {
      setState(() {
        filterTerms['age'] = value.contains("ANY") ? "AGE" : value.substring(5);
      });
    }
    if (value.startsWith("PARTY")) {
      setState(() {
        filterTerms['party'] =
            value.contains("ANY") ? "PARTY" : value.substring(7);
      });
    }
    if (value.startsWith("TYPE")) {
      setState(() {
        filterTerms['type'] =
            value.contains("ANY") ? "TYPE" : value.substring(6);
      });
    }
  }

  void navigateToFavourites(context) {
    setState(() {
      favouriteLordsList = favouriteLordsList;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: Text("Favourite Lords"),
              ),
              body: FavouritesScreen(favouriteLords: favouriteLordsList)));
      // body: Text("HI")));
    }));
  }

  void navigateToAbout(context) {
    print("in about");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text("Favourite Lords"),
            ),
            body: AboutPage(),
          ));
      // body: Text("HI")));
    }));
  }

  void navigateToVisuals(context) {
    print("in visuals");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: Text("Favourite Lords"),
              ),
              body: VisualsPage()));
      // body: Text("HI")));
    }));
  }

  void handleMenuClick(String value, BuildContext context) {
    if (value == 'Filter') {
      setState(() {
        filterTerms = filterOn
            ? {'age': "AGE", 'party': "PARTY", 'type': "TYPE"}
            : filterTerms;
        filterOn = !filterOn;
      });
    }
    if (value == "All Lords") {
      setState(() {
        filterOn = false;
        searching = false;
        filterTerms = {'age': "AGE", 'party': "PARTY", 'type': "TYPE"};
      });
    }
    if (value == "About") {
      navigateToAbout(context);
    }
    if (value == "Visuals") {
      navigateToVisuals(context);
    }
  }

  void addToFavourites(lord) {
    print("ADDING TO FAVOURITES BIATCH");
    // setState(() {
    favouriteLordsList.add(lord);
    // });
    print(favouriteLordsList);
  }

  void removeFromFavourites(lord) {
    print("REMOVING FROM FAVOURITES DUDE");
    // setState(() {
    favouriteLordsList.remove(lord);
    // });
    print(favouriteLordsList);
  }

  void fakeSetState() {
    setState(() {
      toggleThatDoesNothing = !toggleThatDoesNothing;
    });
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
            builder: (context) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'FUCKLORD by LORDCODE',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                          icon: cusIcon,
                          onPressed: () {
                            setState(() {
                              if (this.cusIcon.icon == Icons.search) {
                                this.cusIcon = Icon(Icons.cancel);
                                this.cusSearchBar = TextField(
                                  onChanged: (text) {
                                    print("IN ON CHANGED" + text);
                                    setState(() {
                                      searching = true;
                                      this.searchText = text;
                                    });
                                  },
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.go,
                                  autofocus: true,
                                  showCursor: true,
                                  focusNode: myFocusNode,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "search de cunts",
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                      )),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                );
                              } else {
                                setState(() {
                                  print("resetting state");
                                  this.searchText = "";
                                  searching = false;
                                  this.cusIcon = Icon(Icons.search);
                                  this.cusSearchBar = Text("FUCKLORDS");
                                });
                              }
                            });
                          }),
                      actions: <Widget>[
                        IconButton(
                          onPressed: () {
                            navigateToFavourites(context);
                          },
                          icon: Icon(Icons.favorite),
                        ),
                        PopupMenuButton<String>(
                          tooltip: "hiya! thanks for using our app",
                          elevation: 5,
                          color: Colors.blue,
                          onSelected: (choice) {
                            handleMenuClick(choice, context);
                          },
                          itemBuilder: (BuildContext context) {
                            return {
                              'All Lords',
                              'Filter',
                              'Visuals',
                              'About',
                            }.map((String choice) {
                              return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice,
                                      style: TextStyle(color: Colors.white)));
                            }).toList();
                          },
                        )
                      ],
                      titleSpacing: (40.0),
                      elevation: 30.0,
                      title: cusSearchBar,
                    ),
                    body: Column(children: <Widget>[
                      filterOn
                          ? Container(
                              height: 30,
                              color: Colors.yellow[400],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  PopupMenuButton<String>(
                                    child: Text(
                                      filterTerms['age'],
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onSelected: handleFilterSelection,
                                    itemBuilder: (BuildContext context) {
                                      return {
                                        '< 50',
                                        '50 - 60',
                                        '60-70',
                                        '70-80',
                                        '80-90',
                                        '90+',
                                        'ANY'
                                      }.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: "AGE: $choice",
                                          child: Text(
                                            choice,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  // Text(
                                  //   "AGE",
                                  //   style: TextStyle(color: Colors.blue),
                                  // ),
                                  PopupMenuButton<String>(
                                    child: Text(
                                      filterTerms['party'],
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onSelected: handleFilterSelection,
                                    itemBuilder: (BuildContext context) {
                                      return {
                                        "Conservative",
                                        "Labour",
                                        "Liberal Democrat",
                                        "Green Party",
                                        "Democratic Unionist Party",
                                        "Ulster Unionist Party",
                                        "Plaid Cymru",
                                        "Crossbench",
                                        "Non-affiliated",
                                        "Other",
                                        "ANY"
                                      }.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: "PARTY: $choice",
                                          child: Text(
                                            choice,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  PopupMenuButton<String>(
                                    child: Text(
                                      filterTerms['type'],
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onSelected: handleFilterSelection,
                                    itemBuilder: (BuildContext context) {
                                      return {
                                        'Hereditary',
                                        'Bishop',
                                        "Life Peer",
                                        'ANY',
                                      }.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: "TYPE: $choice",
                                          child: Text(
                                            choice,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ],
                              ))
                          : Container(),
                      Expanded(
                          child: LordsList(
                        favouriteLordsList: favouriteLordsList,
                        fakeSetState: fakeSetState,
                        searching: searching,
                        filterTerms: filterTerms,
                        searchText: searchText,
                        addToFavourites: addToFavourites,
                        removeFromFavourites: removeFromFavourites,
                      )),
                    ]),
                  ),
                )));
  }
}
