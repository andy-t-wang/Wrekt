import 'package:flutter/material.dart';
import 'package:test_app/screens/results/components/body.dart';

class Results extends StatelessWidget {
  final String gameCode, myName;
  final bool win;
  Results(this.gameCode, this.win, this.myName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results (Screenshot to save)"),
      ),
      body: Body(gameCode, win, myName),
    );
  }
}
