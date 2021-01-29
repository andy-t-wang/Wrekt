import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/constants.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CreateInput extends StatelessWidget {
  final MoneyMaskedTextController controller;
  CreateInput(this.controller);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      Text(
        "Bill Total",
        style: TextStyle(
            fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      SizedBox(height: size.height * 0.02),
      Text(
        "*Use the total cost of the bill.*",
        style: TextStyle(
          fontSize: 25,
          color: Colors.blue[700],
        ),
      ),
      SizedBox(height: size.height * 0.05),
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
                    onChanged: (value) {},
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: "xx",
                      prefix: Text('\$ '),
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
