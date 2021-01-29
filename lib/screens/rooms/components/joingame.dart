import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/lobby/lobby.dart';

class JoinGame extends StatelessWidget {
  final TextEditingController codeController;
  final TextEditingController nameController;
  JoinGame(this.codeController, this.nameController);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference games = FirebaseFirestore.instance.collection('games');
    bool isPressed = false;
    Future<void> joinGame() {
      // Call the user's CollectionReference to add a new user
      return FirebaseFirestore.instance
          .collection('games')
          .doc(codeController.text)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists &&
            !documentSnapshot.data()['start'] &&
            documentSnapshot.data()['active']) {
          List<String> players = List.from(documentSnapshot.data()['players']);
          double bill = documentSnapshot.data()['bill'];
          String myName = nameController.text;
          while (players.contains(myName)) {
            var rng = new Random();
            int rand = rng.nextInt(100);
            myName += rand.toString();
          }
          games
              .doc(codeController.text)
              .update({
                //prevent duplicate names in the future
                'players': [...players, myName],
              })
              .then((value) => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => Lobby(
                          codeController.text,
                          documentSnapshot.data()['color'],
                          documentSnapshot.data()['win'],
                          myName,
                          bill.toString()),
                      fullscreenDialog: true)))
              .catchError((error) => print("Failed to update user: $error"));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: new Text("Error Joining"),
                    content: new Text(
                        "This room doesn't exist or the game has already started. Please check your code and try again"),
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
            "Join",
            style: new TextStyle(
              fontSize: 30.0,
            ),
          ),
          autofocus: false,
          clipBehavior: Clip.none,
          onPressed: () {
            if (codeController.text.isEmpty || nameController.text.isEmpty) {
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
              if (!isPressed) {
                joinGame();
                isPressed = true;
              }
            }
          },
        ));
  }
}
