import 'package:flutter/material.dart';
import "classes.dart";
import "LordTile.dart";

class FavouritesScreen extends StatelessWidget {
  final List<Lord> favouriteLords;
  FavouritesScreen({this.favouriteLords});
  @override
  Widget build(BuildContext context) {
    print("IN FAVES SCREEN");

    print(favouriteLords.runtimeType);
    favouriteLords.forEach((lord) => {print(lord.displayName)});

    return Text("HI");
  }
}
