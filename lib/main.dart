import 'package:MPease/favouritesScreen.dart';
import 'package:flutter/material.dart';
import 'lords-list-widget.dart';
import "classes.dart";
import "LordTile.dart";

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
  String searchText = "initial text";
  List<Lord> favouriteLordsList = [];

  void addToFavourites(lord) {
    print("ADDING TO FAVOURITES BIATCH");
    favouriteLordsList.add(lord);
    print(favouriteLordsList);
  }

  void removeFromFavourites(lord) {
    print("REMOVING FROM FAVOURITES DUDE");
    favouriteLordsList.remove(lord);
    print(favouriteLordsList);
  }

  void navigateToFavourites(context) {
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
                                  this.searchText = "initial text";
                                  print(this.searchText);

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
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.menu),
                        ),
                        // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
                        // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
                      ],
                      titleSpacing: (40.0),
                      elevation: 30.0,
                      title: cusSearchBar,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: LordsList(
                        searchText: searchText,
                        addToFavourites: addToFavourites,
                        removeFromFavourites: removeFromFavourites,
                      ),
                    ),
                  ),
                )));
  }
}
