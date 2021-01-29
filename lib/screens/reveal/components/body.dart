import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/reveal/components/winlose.dart';

class Body extends StatelessWidget {
  Body(this.selection, this.correct, this.gameCode, this.myName);
  int selection, correct;
  final String gameCode, myName;
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    CollectionReference collection =
        FirebaseFirestore.instance.collection('games');
    DocumentReference game =
        FirebaseFirestore.instance.collection('games').doc(gameCode);

    Future<void> ifSwapped() {
      if (correct == 1) {
        correct = 2;
      } else {
        correct = 1;
      }
      checked = true;
      print(correct);
      return collection
          .doc(gameCode)
          .update({'guesses.$myName': (selection == correct)})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: game.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        var firestoreData = snapshot.data;
        //check if game started
        // people list
        bool finished = !firestoreData['start'];
        if (finished) {
          game = null;
          // check swap
          bool isSwapped = (firestoreData['swap']);
          if (isSwapped && !checked) {
            ifSwapped();
          }
          return WinLose(selection, correct, gameCode, myName);
        } else {
          return Container(
              width: size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Text(
                      "Waiting for all players to lock in",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ));
        }
      },
    );
  }
}
