import 'package:flutter/material.dart';
import 'package:test_app/constants.dart';
import 'package:test_app/screens/lobby/components/body.dart';

class Lobby extends StatelessWidget {
  final String roomCode, myName, bill;
  final int color, win;
  Lobby(this.roomCode, this.color, this.win, this.myName, this.bill);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(roomCode, myName, bill),
    );
  }
}
