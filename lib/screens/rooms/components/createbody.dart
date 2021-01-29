import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:test_app/constants.dart';
import 'package:test_app/screens/rooms/components/creategame.dart';
import 'package:test_app/screens/rooms/components/createinput.dart';
import 'package:test_app/screens/rooms/components/roominput.dart';

class CreateBody extends StatelessWidget {
  final billController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        width: double.infinity,
        height: size.height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(height: size.height * 0.07),
          CreateInput(billController),
          SizedBox(height: size.height * 0.07),
          Column(
            children: [
              Text(
                "Name",
                style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              RoomInput(nameController),
              SizedBox(height: size.height * 0.07),
              CreateGame(billController, nameController),
            ],
          )
        ]),
      )
    ]);
  }
}
