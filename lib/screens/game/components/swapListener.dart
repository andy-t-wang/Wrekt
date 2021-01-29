import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/game/components/body.dart';

class SwapListener extends StatelessWidget {
  final String roomName;
  final updateSwappedShown;
  final bool isSwappedShown;

  SwapListener(this.roomName, this.updateSwappedShown, this.isSwappedShown);

  @override
  Widget build(BuildContext context) {
    DocumentReference game =
        FirebaseFirestore.instance.collection('games').doc(roomName);
    return StreamBuilder<DocumentSnapshot>(
      stream: game.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 0,
            height: 0,
          );
        }
        bool swap = snapshot.data.data()['swap'];
        if (swap == true && !isSwappedShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            updateSwappedShown();
          });
          WidgetsBinding.instance.addPostFrameCallback((_) => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: new Text("Seer Swapped"),
                          content:
                              new Text("Swap used. Maybe you're onto them!"),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15)),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("Okay"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                    barrierDismissible: true)
              });
          return Container(
            width: 0,
            height: 0,
          );
        }
        return Container(
          width: 0,
          height: 0,
        );
      },
    );
  }
}
