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
              Text("Staff"),
            ],
          ),
        ],
      ),
    );
  }
}

// // https://members-api.parliament.uk/api/Members/3898/Biography
// // https://members-api.parliament.uk/api/Members/3898/Contact
// // https://members-api.parliament.uk/api/Members/3898/ContributionSummary
// //https://members-api.parliament.uk/api/Members/3898/Experience
// // https://members-api.parliament.uk/api/Members/3898/Edms
// https://members-api.parliament.uk/api/Members/3898/Focus
// //https://members-api.parliament.uk/api/Members/History?ids=3898
// https://members-api.parliament.uk/api/Members/3898/Staff
// https://members-api.parliament.uk/api/Members/3898/Synopsis
// https://members-api.parliament.uk/api/Members/3898/Thumbnail
// https://members-api.parliament.uk/api/Members/3898/ThumbnailUrl
// https://members-api.parliament.uk/api/Members/3898/Voting?house=Commons
// https://members-api.parliament.uk/api/Members/3898/WrittenQuestions
// /api/Parties/LordsByType/{forDate}
// /api/Parties/StateOfTheParties/{house}/{forDate}

// Next steps - check out what info wanna display. create classes for the info and the whole network display thing
// also check out the thumbnail URL situ and if it loads quicker
