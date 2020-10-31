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

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
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
            onPressed: () {},
            icon: Icon(Icons.menu),
          ),
          actions: <Widget>[
            IconButton(
                icon: cusIcon,
                onPressed: () {
                  setState(() {
                    if (this.cusIcon.icon == Icons.search) {
                      this.cusIcon = Icon(Icons.cancel);
                      this.cusSearchBar = TextField(
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
                        textInputAction: TextInputAction.go,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      );
                    } else {
                      this.cusIcon = Icon(Icons.search);
                      this.cusSearchBar = Text("FUCKLORDS");
                    }
                  });
                }),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
          ],
          titleSpacing: (40.0),
          elevation: 30.0,
          title: cusSearchBar,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: LordsList()),
      ),
    );
  }
}
