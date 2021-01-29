import 'package:flutter/material.dart';

class RoomCode extends StatelessWidget {
  final String roomCode;
  RoomCode(this.roomCode);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.03),
        Text(
          "Room Code:",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          "$roomCode",
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
