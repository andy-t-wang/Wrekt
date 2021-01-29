import 'package:flutter/material.dart';
import 'package:test_app/constants.dart';
import 'package:test_app/screens/rooms/components/createbody.dart';

class CreateRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CreateBody(),
    );
  }
}
