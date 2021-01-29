import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/game/guessing.dart';

class PeopleList extends StatelessWidget {
  final String gameCode, myName;
  PeopleList(this.gameCode, this.myName);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DocumentReference game =
        FirebaseFirestore.instance.collection('games').doc(gameCode);

    return StreamBuilder<DocumentSnapshot>(
      stream: game.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        var firestoreData = snapshot.data;
        //check if game started
        // people list
        if (firestoreData == null) {
          return Container();
        }
        List<String> names = List.from(firestoreData['players']);
        bool started = firestoreData['start'];
        if (started) {
          int seer = firestoreData['seer'];
          int win = firestoreData['win'];
          int color = firestoreData['color'];
          String seerName = names[seer];
          Future.microtask(() => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => Guessing(seerName == myName, win, color,
                      myName, seerName, gameCode),
                  fullscreenDialog: true)));
          return Container();
        }
        if (!firestoreData['start']) {
          if (!names.contains(myName)) {
            Future.microtask(() =>
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false));
          }
          return Container(
              width: size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "People",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  for (int i = 0; i < names.length; i++)
                    Column(children: [
                      PersonList(
                        name: names[i],
                        number: (i + 1).toString(),
                        gameCode: gameCode,
                      ),
                      SizedBox(height: 10)
                    ])
                ],
              ));
        }
      },
    );
  }
}

class PersonList extends StatelessWidget {
  const PersonList({
    Key key,
    this.number,
    this.name,
    this.gameCode,
  }) : super(key: key);

  final String number, name, gameCode;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<void> leaveGame() {
      // Call the user's CollectionReference to add a new user
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('games').doc(gameCode);

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
          .then((value) => print("removed player"))
          .catchError((error) => print("Failed to remove player"));
    }

    return Container(
      width: size.width * 0.9,
      padding: EdgeInsets.fromLTRB(8, 8, 3, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        shape: BoxShape.rectangle,
        color: Colors.grey[300],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(
              "$number. ",
              style: TextStyle(
                  fontSize: 27,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "$name",
              style: TextStyle(
                fontSize: 27,
                color: Colors.black,
              ),
            )
          ]),
          IconButton(
              icon: Icon(Icons.close),
              tooltip: 'Increase volume by 10',
              onPressed: () {
                leaveGame();
              }),
        ],
      ),
    );
  }
}
