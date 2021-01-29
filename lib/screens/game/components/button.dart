import 'package:flutter/material.dart';

class ButtonChoice extends StatelessWidget {
  const ButtonChoice({Key key, this.color, this.updateSelection, this.number})
      : super(key: key);

  final Function updateSelection;
  final int color, number;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
        // alignment: Alignment.bottomCenter, children: [
        //   Container(
        //       height: size.height * 0.5,
        //       width: size.width,
        //       child: FlatButton(
        //         child: Text(
        //           "1",
        //           style: new TextStyle(
        //               fontSize: size.height * 0.068,
        //               color: Colors.grey[800],
        //               fontStyle: FontStyle.italic,
        //               fontWeight: FontWeight.w900),
        //         ),
        //         color: colors[color],
        //         autofocus: false,
        //         clipBehavior: Clip.none,
        //         onPressed: () {
        //           updateSelection(number);
        //         },
        //       )),
        //   Visibility(
        //       visible: (selection == 1), // condition here
        //       child: Positioned(
        //         bottom: size.height * 0.08,
        //         child: Row(children: [
        //           Icon(
        //             Icons.check_circle_rounded,
        //             color: colors[widget.color + 1],
        //             size: size.height * 0.05,
        //             semanticLabel: 'Text to announce in accessibility modes',
        //           ),
        //           Padding(
        //               padding: EdgeInsets.all(12.0),
        //               child: Text(
        //                 "Selected",
        //                 style: TextStyle(
        //                     fontSize: size.height * 0.035,
        //                     fontWeight: FontWeight.bold),
        //               ))
        //         ]),
        //       ))
        );
  }
}
