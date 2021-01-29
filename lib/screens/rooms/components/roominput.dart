import 'package:flutter/material.dart';
import 'package:test_app/constants.dart';

class RoomInput extends StatelessWidget {
  final TextEditingController controller;
  RoomInput(this.controller);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      SizedBox(height: size.height * 0.02),
      Container(
          margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          width: size.width * .6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 50,
                color: Colors.black.withOpacity(0.13),
              ),
            ],
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 35),
                    controller: controller,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: "xxxx",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 25),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      // surffix isn't working properly  with SVG
                      // thats why we use row
                      // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                    ),
                  ),
                ),
              ]))
    ]);
  }
}
