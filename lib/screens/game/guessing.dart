import 'package:flutter/material.dart';
import 'package:test_app/screens/game/components/body.dart';

class Guessing extends StatefulWidget {
  final bool isSeer;
  final int win, color;
  final String myName, seerName, roomCode;
  Guessing(this.isSeer, this.win, this.color, this.myName, this.seerName,
      this.roomCode);
  @override
  _Guessing createState() => _Guessing();
}

class _Guessing extends State<Guessing> {
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this._showSeer();
    });
  }

  _showSeer() {
    String seerName = widget.seerName;
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: new Text("Seer Name"),
              content: new Text(widget.isSeer
                  ? "You are the seer. Try to mislead everyone into clicking the bad option. They don't know which is which."
                  : "$seerName is the seer this game. Try to figure out which is the good button, they can see the answer."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(widget.isSeer, widget.win, widget.color, widget.myName,
          widget.roomCode),
    );
  }
}
