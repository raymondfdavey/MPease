import 'package:MPease/lords-expansion-1.dart';
import 'package:MPease/lords-expansion-2.dart';
import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';
import 'package:intl/intl.dart';

class LordsExpansion1 extends StatefulWidget {
  final Lord lord;
  LordsExpansion1({Key key, this.lord}) : super(key: key);
  @override
  _LordsExpansion1State createState() => _LordsExpansion1State(lord);
}

class _LordsExpansion1State extends State<LordsExpansion1> {
  Lord lord;
  _LordsExpansion1State(this.lord);
  bool fetchingUrl = true;
  bool urlError = false;

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

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        onExpansionChanged: (onExpansionChanged) =>
            {testImageUrl(lord.pictureUrl)},
        title: Text('${lord.displayName}'),
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
                ]),
                Column(children: <Widget>[
                  Text('${lord.memberId}'),
                  // Text('${lord.memberId}'),

                  Text('Gender: ${lord.gender}'),
                  Text('Started Lording:' +
                      DateFormat('yyyy-MM-dd').format(lord.startedLording)),
                  Text('Type: ${lord.memberFrom}'),
                  Text('Party: ${lord.party}'),
                  Text('Born: ' + DateFormat('yyyy-MM-dd').format(lord.dob)),
                ])
              ]),
            ],
          ),
          Expansion2(id: lord.memberId)
        ]);
  }
}
