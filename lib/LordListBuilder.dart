import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'network.dart';
import 'classes.dart';
import "utilities.dart";

class LordsListBuilder extends StatelessWidget {
  LordsListBuilder(this.lords);
  final List<Lord> lords;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: lords.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
              title: Text('${lords[index].title}'),
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
                    Text('years lording: ${lords[index].beganLordingInYears}'),
                    ExpansionTile(
                        title: Text('Registered Interests'),
                        children: <Widget>[
                          Text("HI HI HI"),
                          Text('${lords[index].interests[0].interestCategory}'),
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
        });
  }
}
