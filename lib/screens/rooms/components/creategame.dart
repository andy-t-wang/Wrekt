import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:test_app/screens/lobby/lobby.dart';
import 'dart:math';

class CreateGame extends StatelessWidget {
  final MoneyMaskedTextController billController;
  final TextEditingController nameController;
  CreateGame(this.billController, this.nameController);

  final _chars = 'abcdefghijklmnopqrstuvwxyz234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('games');
    bool isClicked = false;
    Future<void> createGame() {
      String roomCode = getRandomString(4);
      Random random = new Random();
      int val = random.nextInt(11);
      int win = random.nextInt(2) + 1;
      return FirebaseFirestore.instance
          .collection('games')
          .doc(roomCode)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        var now = new DateTime.now();
        var lastUsed;
        if (documentSnapshot.exists) {
          lastUsed = DateTime.parse(
              documentSnapshot.data()['time'].toDate().toString());
        }
        if (documentSnapshot.exists &&
            documentSnapshot.data()['active'] &&
            (now.difference(lastUsed).inDays < 1)) {
          //find a new room
          return createGame();
        } else {
          return users
              .doc(roomCode)
              .set({
                'game_code': roomCode,
                'players': [nameController.text],
                'bill': billController.numberValue,
                'color': val,
                'win': win,
                'start': false,
                'guesses': {},
                'active': true,
                'seer': 0,
                'time': now,
              })
              .then((value) => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => Lobby(roomCode, val, win,
                            nameController.text, billController.text),
                        fullscreenDialog: true),
                  ))
              .catchError((error) => print("Failed to add user: $error"));
        }
      });
    }

    return Container(
        height: size.height * 0.075,
        width: size.width * 0.35,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
        child: ElevatedButton(
          child: Text(
            "Create",
            style: new TextStyle(
              fontSize: 30.0,
            ),
          ),
          autofocus: false,
          clipBehavior: Clip.none,
          onPressed: () {
            if (billController.text.isEmpty || nameController.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: new Text("Missing Info"),
                        content: new Text("Please fill out both fields."),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15)),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Done"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                  barrierDismissible: true);
            } else {
              if (!isClicked) {
                createGame();
                isClicked = true;
              }
            }
          },
        ));
  }
}
