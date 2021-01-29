import 'package:flutter/material.dart';
import 'package:test_app/screens/rooms/components/joingame.dart';
import 'package:test_app/screens/rooms/components/roominput.dart';

class Body extends StatelessWidget {
  final roomCodeController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Room Code",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            RoomInput(roomCodeController),
            SizedBox(height: size.height * 0.05),
            Text(
              "Name",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            RoomInput(nameController),
            SizedBox(height: size.height * 0.07),
            JoinGame(roomCodeController, nameController)
          ]),
    );
  }
}
