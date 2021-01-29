import 'package:flutter/material.dart';

class PeopleList extends StatelessWidget {
  final String gameCode;
  final double newHighPrice, newLowPrice;
  final Map<String, dynamic> guesses;
  PeopleList(this.gameCode, this.newHighPrice, this.newLowPrice, this.guesses);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "People",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            for (var k in guesses.keys)
              PersonList(
                  number: k, cost: guesses[k] ? newLowPrice : newHighPrice)
          ],
        ));
  }
}

class PersonList extends StatelessWidget {
  const PersonList({
    Key key,
    this.number,
    this.cost,
  }) : super(key: key);

  final String number;
  final double cost;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String roundedCost = cost.toStringAsFixed(2);

    return Container(
      width: size.width * .9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$number ",
            style: TextStyle(fontSize: 25),
          ),
          Text(
            "\$$roundedCost",
            style: TextStyle(fontSize: 25),
          )
        ],
      ),
    );
  }
}
