import 'package:flutter/material.dart';
import 'package:test_app/screens/reveal/components/body.dart';

class RevealScreen extends StatelessWidget {
  RevealScreen(
      this.color, this.selection, this.win, this.gameCode, this.myName);
  final int selection, win;
  final Color color;
  final String gameCode, myName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Body(selection, win, gameCode, myName),
    );
  }
}
