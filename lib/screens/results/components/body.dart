import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/lobby/lobby.dart';
import 'package:test_app/screens/results/components/code.dart';
import 'package:test_app/screens/results/components/people.dart';

class Body extends StatelessWidget {
  final String gameCode, myName;
  final bool win;
  Body(this.gameCode, this.win, this.myName);
  @override
  Widget build(BuildContext context) {
    CollectionReference games = FirebaseFirestore.instance.collection('games');

    Future<void> joinGame() {
      // Call the user's CollectionReference to add a new user
      return FirebaseFirestore.instance
          .collection('games')
          .doc(gameCode)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists &&
            !documentSnapshot.data()['start'] &&
            documentSnapshot.data()['active']) {
          List<String> players = List.from(documentSnapshot.data()['players']);
          double bill = documentSnapshot.data()['bill'];
          String myName = this.myName;
          while (players.contains(myName)) {
            var rng = new Random();
            int rand = rng.nextInt(100);
            myName += rand.toString();
          }
          games
              .doc(gameCode)
              .update({
                //prevent duplicate names in the future
                'players': [...players, myName],
              })
              .then((value) => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => Lobby(
                          gameCode,
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
    //make game active again on play again

    Future<void> finishGame() {
      // Call the user's CollectionReference to add a new user
      DocumentReference documentReference = games.doc(gameCode);
      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
            // Get the document
            DocumentSnapshot snapshot =
                await transaction.get(documentReference);

            if (!snapshot.exists) {
              throw Exception("Can't finish game, game does not exist");
            }

            List<dynamic> players = snapshot.data()['players'];
            players.remove(myName);
            // Perform an update on the document
            transaction.update(documentReference, {'players': players});

            if (players.length == 0) {
              transaction.update(documentReference, {'active': false});
            }

            // Return the new count
            return true;
          })
          .then((value) => print("Successfully finished game"))
          .catchError((error) => print("Failed to finish game"));
    }

    Size size = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot>(
      future: games.doc(gameCode).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> firestoreData = snapshot.data.data();
          var names = firestoreData['guesses'];
          var winners =
              names.entries.where((person) => person.value == true).length;
          int numPlayers = names.entries.length;
          double bill = firestoreData['bill'];
          double normalPrice = bill / numPlayers;
          double newHighPrice = normalPrice * 1.25;
          double newLowPrice =
              (bill - newHighPrice * (numPlayers - winners)) / winners;
          String normalString = normalPrice.toStringAsFixed(2);
          return ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RoomCode(win
                    ? newLowPrice.toStringAsFixed(2)
                    : newHighPrice.toStringAsFixed(2)),
                SizedBox(height: 10),
                Divider(
                  color: Colors.black,
                  height: 10,
                  thickness: 0.9,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(height: 5),
                PeopleList(gameCode, newHighPrice, newLowPrice,
                    firestoreData['guesses']),
                Divider(
                  color: Colors.black,
                  height: 30,
                  thickness: 0.5,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  "Your Price Change:\n \$$normalString-> \$" +
                      (win
                          ? newLowPrice.toStringAsFixed(2)
                          : newHighPrice.toStringAsFixed(2)),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  "Bill Total: \$ $bill",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                    height: size.height * 0.075,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: ElevatedButton(
                      child: Text(
                        "Finish",
                        style: new TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                      autofocus: false,
                      clipBehavior: Clip.none,
                      onPressed: () {
                        finishGame();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (_) => false);
                      },
                    )),
                SizedBox(height: size.height * 0.02),
                Container(
                    height: size.height * 0.075,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: ElevatedButton(
                      child: Text(
                        "Play Again",
                        style: new TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                      autofocus: false,
                      clipBehavior: Clip.none,
                      onPressed: () {
                        joinGame();
                      },
                    )),
                SizedBox(height: size.height * 0.02),
              ],
            )
          ]);
        }

        return Text("loading");
      },
    );
  }
}
