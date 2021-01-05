import 'package:MPease/lords-expansion-2.dart';
import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';
import 'package:intl/intl.dart';
import "lordDetailsScreen.dart";

class LordTile extends StatefulWidget {
  final Lord lord;
  final addToFavourites;
  final removeFromFavourites;
  final bool isFavouriteList;
  LordTile(
      {Key key,
      this.lord,
      this.addToFavourites,
      this.removeFromFavourites,
      this.isFavouriteList = false})
      : super(key: key);
  @override
  _LordTileState createState() => _LordTileState(
      lord, addToFavourites, removeFromFavourites, isFavouriteList);
}

class _LordTileState extends State<LordTile> {
  Lord lord;
  Function addToFavourites;
  Function removeFromFavourites;
  bool isFavouriteList;
  _LordTileState(this.lord, this.addToFavourites, this.removeFromFavourites,
      this.isFavouriteList);
  bool fetchingUrl = true;
  bool urlError = false;
  bool isFavourite = false;

  void testImageUrl(String url) async {
    bool answer = await attemptPictureUrl(url);
    if (answer == false) {
      setState(() {
        fetchingUrl = false;
        urlError = true;
      });
    } else {
      setState(() {
        fetchingUrl = false;
        urlError = false;
      });
    }
  }

  void isFavouriteLordToggle() {
    print("TOGGLING FAVOURITE IN");
    print(lord);
    if (isFavourite) {
      setState(() {
        isFavourite = false;
      });
    } else {
      setState(() {
        isFavourite = true;
      });
    }
  }

  void navigateToDetailsScreen(context, lord) {
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
            title: Text('${lord.displayName}'),
          ),
          body: LordsDetailsScreen(lord),
        ),
      );
      // body: Text("HI")));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ExpansionTile(
            onExpansionChanged: (onExpansionChanged) =>
                {testImageUrl(lord.pictureUrl)},
            title: Text('${lord.displayName}'),
            leading: !isFavouriteList
                ? IconButton(
                    onPressed: () {
                      print("HI BUTTON PRESSED");
                      if (!isFavourite) {
                        addToFavourites(this.lord);
                      } else {
                        removeFromFavourites(this.lord);
                      }
                      isFavouriteLordToggle();
                    },
                    icon: isFavourite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    color: isFavourite ? Colors.red : null,
                  )
                : null,
            children: <Widget>[
          Column(
            children: [
              Row(children: <Widget>[
                Column(children: <Widget>[
                  !fetchingUrl && !urlError
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            lord.pictureUrl,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                            height: 80,
                            width: 80,
                          ),
                        )
                      : !fetchingUrl && urlError
                          ? Text("NO IMAGE SOZ")
                          : CircularProgressIndicator(),
                  TextButton(
                      onPressed: () {
                        print("IN GET ME MORE DETAILS");
                        navigateToDetailsScreen(context, lord);
                      },
                      child: Text("MORE DETAILS")),
                ]),
                Column(children: <Widget>[
                  Text('${lord.memberId}'),
                  // Text('${lord.memberId}'),

                  Text('Gender: ${lord.gender}'),
                  Text('Started Lording: ${lord.startedLording}'),
                  Text('Type: ${lord.memberFrom}'),
                  Text('Party: ${lord.party}'),
                  Text('Age: ${lord.dob}'),
                ])
              ]),
            ],
          ),
          Expansion2(id: lord.memberId)
        ]));
  }
}
