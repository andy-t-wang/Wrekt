import 'package:flutter/material.dart';

class RoomCode extends StatelessWidget {
  final String owe;
  RoomCode(this.owe);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.03),
        Text(
          "You Owe",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          "\$$owe",
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
