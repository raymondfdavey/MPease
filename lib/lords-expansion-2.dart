import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';

class Expansion2 extends StatefulWidget {
  final int id;
  Expansion2({Key key, this.id}) : super(key: key);
  @override
  _Expansion2State createState() => _Expansion2State(id);
}

class _Expansion2State extends State<Expansion2> {
  int id;
  _Expansion2State(this.id);
  bool loadingRegInterests = true;
  List<Interest> interests;

  void getInterests(int id) async {
    List<Interest> returnedInterests = await fetchInterestsById(id);
    print(returnedInterests);
    setState(() {
      interests = returnedInterests;
      loadingRegInterests = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text('Registered Interests'),
        onExpansionChanged: (onExpansionChanged) => {getInterests(id)},
        children: loadingRegInterests
            ? <Widget>[CircularProgressIndicator()]
            : <Widget>[
                SizedBox(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: interests.length,
                        itemBuilder: (BuildContext ctx, int i) {
                          return Column(children: <Widget>[
                            Text('${interests[i].interestCategory}'),
                            Text('${interests[i].interestTitle}')
                          ]);
                        }))
              ]);
  }
}
