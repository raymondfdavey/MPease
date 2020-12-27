import 'package:flutter/material.dart';
import 'lords-list-widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Icon cusIcon = Icon(Icons.search);

  Widget cusSearchBar = Text("FUCKLORDS");
  FocusNode myFocusNode;
  String searchText = "initial text";
  bool goToSaved = false;

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

  goToSavedToggle() {
    print("HERE");
    goToSaved
        ? setState(() {
            goToSaved = false;
          })
        : setState(() {
            goToSaved = true;
          });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FUCKLORD by LORDCODE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: goToSavedToggle,
            icon: Icon(Icons.favorite),
          ),
          actions: <Widget>[
            IconButton(
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
            saved: goToSaved,
            savedToggle: goToSavedToggle,
          ),
        ),
      ),
    );
  }
}
