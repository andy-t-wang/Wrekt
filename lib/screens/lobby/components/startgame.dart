import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/constants.dart';

class StartGame extends StatelessWidget {
  final String roomCode;
  StartGame(this.roomCode);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isPressed = false;
    Future<void> startGame() {
      // Call the user's CollectionReference to add a new user
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('games').doc(roomCode);
      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
            DocumentSnapshot documentSnapshot =
                await transaction.get(documentReference);

            if (documentSnapshot.exists &&
                !documentSnapshot.data()['start'] &&
                documentSnapshot.data()['active']) {
              int players = documentSnapshot.data()['players'].length;
              Random _random = new Random();
              int seer = _random.nextInt(players);
              while (players > 1 && seer == documentSnapshot.data()['seer']) {
                seer = _random.nextInt(players);
              }
              if (players == 1) {
                seer = 0;
              }
              int win = _random.nextInt(2) + 1;
              transaction.update(documentReference, {
                'start': true,
                'guesses': {},
                'seer': seer,
                'win': win,
                'swap': false
              });
              return "updated";
            }
            return "didnt update";
          })
          .then((value) => print("$value"))
          .catchError((error) => print("Start game error: $error"));
      ;
    }

    return Container(
        height: size.height * 0.075,
        width: size.width * 0.5,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
        child: FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          child: Text(
            "Start",
            style: new TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
          autofocus: false,
          color: kPrimaryColor,
          clipBehavior: Clip.none,
          onPressed: () {
            if (!isPressed) {
              startGame();
              isPressed = true;
            }
          },
        ));
  }
}
