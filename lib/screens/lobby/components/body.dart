import 'package:flutter/material.dart';
import 'package:test_app/screens/lobby/components/code.dart';
import 'package:test_app/screens/lobby/components/leavegame.dart';
import 'package:test_app/screens/lobby/components/people.dart';
import 'package:test_app/screens/lobby/components/startgame.dart';

class Body extends StatelessWidget {
  final String roomCode, myName, bill;

  Body(this.roomCode, this.myName, this.bill);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoomCode(roomCode),
          SizedBox(height: 10),
          Divider(
            color: Colors.black,
            height: 10,
            thickness: 0.9,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(height: 5),
          PeopleList(roomCode, myName),
          Divider(
            color: Colors.black,
            height: 30,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(height: size.height * 0.05),
          Text(
            "Bill Total: \$$bill",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.05),
          StartGame(roomCode),
          SizedBox(height: size.height * 0.02),
          LeaveGame(roomCode, myName)
        ],
      ))
    ]);
  }
}
