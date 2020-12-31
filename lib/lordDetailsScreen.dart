import 'package:flutter/material.dart';
import 'classes.dart';

class LordsDetailsScreen extends StatefulWidget {
  final Lord lord;
  LordsDetailsScreen(this.lord);
  @override
  _LordsDetailsScreenState createState() => _LordsDetailsScreenState();
}

class _LordsDetailsScreenState extends State<LordsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Lord lord = widget.lord;
    print(lord.displayName);
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Picture"),
                Column(
                  children: [
                    Text("Deets1"),
                    Text("Deets1"),
                    Text("Deets1"),
                    Text("Deets1"),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text("REG INT"),
              Text("Questions"),
              Text("Voting"),
              Text("Sexual Proclivities"),
            ],
          ),
        ],
      ),
    );
  }
}
