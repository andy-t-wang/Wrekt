import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaveGame extends StatelessWidget {
  final String roomCode, name;
  LeaveGame(this.roomCode, this.name);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<void> leaveGame() {
      // Call the user's CollectionReference to add a new user
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('games').doc(roomCode);

      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
            // Get the document
            DocumentSnapshot snapshot =
                await transaction.get(documentReference);

            if (!snapshot.exists) {
              throw Exception("Game does not exist!");
            }

            // Update the follower count based on the current count
            // Note: this could be done without a transaction
            // by updating the population using FieldValue.increment()

            List<dynamic> players = snapshot.data()['players'];
            players.remove(name);
            // Perform an update on the document
            transaction.update(documentReference, {'players': players});
            if (players.length == 0) {
              transaction.update(documentReference, {'active': false});
            }
            // Return the new count
            return true;
          })
          .then((value) =>
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false))
          .catchError((error) => print("Failed to leave game"));
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
            "Leave",
            style: new TextStyle(fontSize: 30.0, color: Colors.white),
          ),
          color: Colors.redAccent,
          autofocus: false,
          clipBehavior: Clip.none,
          onPressed: () {
            leaveGame();
          },
        ));
  }
}
