import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:test_app/screens/game/components/lockindialog.dart';
import 'package:test_app/screens/game/components/swapListener.dart';
import 'package:test_app/screens/reveal/reveal.dart';

class Body extends StatefulWidget {
  // 0 none, 1 first, 2 second
  int color, win;
  final bool isSeer;
  final String myName, roomCode;
  Body(this.isSeer, this.win, this.color, this.myName, this.roomCode);
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  int win = 1;
  int endTime = 0;
  CountdownTimerController controller;

  initState() {
    super.initState();
    win = widget.win;
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 5 * 60;
    controller = CountdownTimerController(endTime: endTime, onEnd: null);
  }

  bool swapped = false;
  bool isSwappedShown = false;
  _swapped() => setState(() => swapped = !swapped);
  _updateWin(int value) => setState(() => win = value);
  int selection = 1;
  _updateSelection(int value) => setState(() => selection = value);

  _swapDialogueShown() {
    setState(() {
      isSwappedShown = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List colors = [
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.pink,
      Colors.blue,
      Colors.amber,
      Colors.cyan,
      Colors.grey,
      Colors.purple,
      Colors.lime,
      Colors.orange,
      Colors.blueGrey
    ];

    CollectionReference game = FirebaseFirestore.instance.collection('games');
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('games').doc(widget.roomCode);
    Future<void> lockinAnswer() {
      String myName = widget.myName;
      return game
          .doc(widget.roomCode)
          .update({'guesses.$myName': win == selection})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    Future<void> swap() {
      // Call the user's CollectionReference to add a new user
      _updateWin(win == 1 ? 2 : 1);
      _swapped();
      return game
          .doc(widget.roomCode)
          .update({'win': win, 'swap': true})
          .then((value) => print("Swapped Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    Future<void> seerFinish() {
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

            int players = snapshot.data()['players'].length - 1;
            int guesses = snapshot.data()['guesses'].entries.length;
            if (guesses < players) {
              print('here');
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: new Text("Not all players have locked in"),
                        content: new Text(
                            "Make sure everyone locks in before you finish the game."),
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
                  barrierDismissible: true);
              return {'success': false, 'selected': null};
            }
            int winners = snapshot
                .data()['guesses']
                .entries
                .where((person) => person.value == true)
                .length;
            int losers = players - winners;
            bool choice = winners >= losers ? false : true;
            // Perform an update on the document
            String myName = widget.myName;
            int opp = win == 1 ? 2 : 1;
            int selectedInt = choice ? win : opp;
            int oldwinner = win;
            if (swapped) {
              selectedInt = choice ? opp : win;
              oldwinner = opp;
            }
            transaction.update(documentReference,
                {'guesses.$myName': choice, 'start': false, 'players': []});

            // Return the new count
            return {
              'success': true,
              'selected': selectedInt,
              'win': oldwinner,
            };
          })
          .then((value) => {
                value['success']
                    ? Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RevealScreen(
                                colors[widget.color + selection - 1],
                                value['selected'],
                                value['win'],
                                widget.roomCode,
                                widget.myName),
                            fullscreenDialog: true),
                        ModalRoute.withName("/game"))
                    : null
              })
          .catchError(
              (error) => print("Failed to update user followers: $error"));
    }

    Future<void> timerFinishedPlayer() {
      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
            // Get the document
            DocumentSnapshot snapshot =
                await transaction.get(documentReference);

            if (!snapshot.exists) {
              throw Exception("Game does not exist!");
            }

            String myName = widget.myName;
            transaction.update(
                documentReference, {'guesses.$myName': win == selection});

            // Return the new count
            return {
              'success': true,
            };
          })
          .then((value) => {
                value['success']
                    ? Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => RevealScreen(
                                colors[widget.color + selection - 1],
                                selection,
                                win,
                                widget.roomCode,
                                widget.myName),
                            fullscreenDialog: true),
                      )
                    : null
              })
          .catchError(
              (error) => print("Failed to update user followers: $error"));
    }

    _confirmRegister() {
      var baseDialog = LockInDialog(
          title: "Lock In?",
          content: "You cannot change your choice after locking in.",
          yesOnPressed: () {
            lockinAnswer();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => RevealScreen(
                      colors[widget.color + selection - 1],
                      selection,
                      win,
                      widget.roomCode,
                      widget.myName),
                  fullscreenDialog: true),
            );
          },
          noOnPressed: () {
            Navigator.of(context).pop();
          },
          yes: "Yes",
          no: "Cancel");

      showDialog(
          context: context,
          builder: (BuildContext context) => baseDialog,
          barrierDismissible: true);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SwapListener(widget.roomCode, _swapDialogueShown, isSwappedShown),
        Stack(alignment: Alignment.center, children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(alignment: Alignment.bottomCenter, children: [
                  Container(
                      height: size.height * 0.5,
                      width: size.width,
                      child: FlatButton(
                        child: (widget.isSeer)
                            ? Text(
                                (win == 1) ? "Good" : "Bad",
                                style: new TextStyle(
                                    fontSize: size.height * 0.068,
                                    color: Colors.grey[800],
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w900),
                              )
                            : Text(
                                "1",
                                style: new TextStyle(
                                    fontSize: size.height * 0.068,
                                    color: Colors.grey[800],
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w900),
                              ),
                        color: colors[widget.color],
                        disabledColor: colors[widget.color],
                        autofocus: false,
                        clipBehavior: Clip.none,
                        onPressed: widget.isSeer
                            ? null
                            : () {
                                _updateSelection(1);
                              },
                      )),
                  Visibility(
                      visible:
                          (selection == 1 && !widget.isSeer), // condition here
                      child: Positioned(
                        bottom: size.height * 0.08,
                        child: Row(children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: colors[widget.color + 1],
                            size: size.height * 0.05,
                            semanticLabel: 'Button Selected',
                          ),
                          Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                "Selected",
                                style: TextStyle(
                                    fontSize: size.height * 0.035,
                                    fontWeight: FontWeight.bold),
                              ))
                        ]),
                      )),
                  Positioned(
                      top: size.height * 0.08,
                      child: CountdownTimer(
                        controller: controller,
                        // onEnd: () {
                        //   if (widget.isSeer) {
                        //     print("seer finished");
                        //     seerFinish();
                        //   } else {
                        //     print("player finished");
                        //     timerFinishedPlayer();
                        //   }
                        // },
                        widgetBuilder: (_, CurrentRemainingTime time) {
                          if (time == null) {
                            return Text('Game over');
                          }
                          List<Widget> list = [
                            Row(
                              children: <Widget>[
                                Text(
                                  "Time Left: ",
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ];
                          if (time.min != null) {
                            list.add(Row(
                              children: <Widget>[
                                Text(
                                  time.min.toString() + ":",
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ));
                          }
                          if (time.sec != null) {
                            list.add(Row(
                              children: <Widget>[
                                Text(
                                    (time.sec < 10)
                                        ? "0" + time.sec.toString()
                                        : time.sec.toString(),
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ));
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: list,
                          );
                        },
                      ))
                ]),
                Stack(alignment: Alignment.bottomCenter, children: [
                  Container(
                      height: size.height * 0.5,
                      width: size.width,
                      child: FlatButton(
                        child: (widget.isSeer)
                            ? Text(
                                (win == 2) ? "Good" : "Bad",
                                style: new TextStyle(
                                    fontSize: size.height * 0.068,
                                    color: Colors.grey[800],
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w900),
                              )
                            : Text(
                                "2",
                                style: new TextStyle(
                                    fontSize: size.height * 0.068,
                                    color: Colors.grey[800],
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w900),
                              ),
                        color: colors[widget.color + 1],
                        disabledColor: colors[widget.color + 1],
                        autofocus: false,
                        clipBehavior: Clip.none,
                        onPressed: widget.isSeer
                            ? null
                            : () {
                                _updateSelection(2);
                              },
                      )),
                  Visibility(
                      visible:
                          (selection == 2 && !widget.isSeer), // condition here
                      child: Positioned(
                        bottom: size.height * 0.08,
                        child: Row(children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: colors[widget.color],
                            size: size.height * 0.05,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                "Selected",
                                style: TextStyle(
                                    fontSize: size.height * 0.035,
                                    fontWeight: FontWeight.bold),
                              ))
                        ]),
                      ))
                ])
              ]),
          Visibility(
            visible: (!widget.isSeer),
            child: Container(
                height: size.height * 0.12,
                width: size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Colors.black.withOpacity(0.23),
                    ),
                  ],
                ),
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  child: Text(
                    "Lock In",
                    style: new TextStyle(
                        fontSize: size.height * 0.038,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w900),
                  ),
                  color: Colors.limeAccent,
                  autofocus: false,
                  clipBehavior: Clip.none,
                  onPressed: () {
                    _confirmRegister();
                  },
                )),
          ),
          Visibility(
            visible: (widget.isSeer),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: size.height * 0.12,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Colors.black.withOpacity(0.23),
                          ),
                        ],
                      ),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        child: Text(
                          "Finish",
                          style: new TextStyle(
                              fontSize: size.height * 0.038,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w900),
                        ),
                        color: Colors.limeAccent,
                        autofocus: false,
                        clipBehavior: Clip.none,
                        onPressed: () {
                          seerFinish();
                        },
                      )),
                  Container(
                      height: size.height * 0.12,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Colors.black.withOpacity(0.23),
                          ),
                        ],
                      ),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        child: Text(
                          "Swap",
                          style: new TextStyle(
                              fontSize: size.height * 0.038,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w900),
                        ),
                        color: Colors.limeAccent,
                        autofocus: false,
                        clipBehavior: Clip.none,
                        disabledColor: Colors.transparent,
                        onPressed: swapped
                            ? null
                            : () {
                                swap();
                              },
                      ))
                ]),
          )
        ])
      ],
    );
  }
}
