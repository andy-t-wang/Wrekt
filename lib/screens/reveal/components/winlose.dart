import 'package:flutter/material.dart';
import 'package:test_app/screens/results/results.dart';

class WinLose extends StatelessWidget {
  WinLose(this.selection, this.correct, this.gameCode, this.myName);
  final int selection, correct;
  final String gameCode, myName;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListView(children: [
      Container(
          width: size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: size.height * .05),
            Text(
              "Choice $selection Selected",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: size.height * .02),
            Visibility(
                visible: (selection == correct),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    "Winner! Nice work you gooned some fools. You're just built different.",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )),
            Visibility(
                visible: (selection != correct),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        "Rip you lost. \nYou got got. Gonna have to pay up.",
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                  SizedBox(height: size.height * .04),
                  Image(image: AssetImage('assets/vector.png')),
                ])),
            SizedBox(height: size.height * .05),
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Results(gameCode, selection == correct, myName)));
                  },
                )),
            SizedBox(height: size.height * .02),
          ]))
    ]);
  }
}
