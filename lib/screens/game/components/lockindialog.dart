import 'package:flutter/material.dart';

class LockInDialog extends StatelessWidget {
  //When creating please recheck 'context' if there is an error!

  const LockInDialog(
      {Key key,
      this.yes,
      this.no,
      this.title,
      this.content,
      this.noOnPressed,
      this.yesOnPressed})
      : super(key: key);

  final String yes, no, title, content;
  final Function yesOnPressed, noOnPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(this.title),
      content: new Text(this.content),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        new FlatButton(
          child: new Text(this.yes),
          onPressed: () {
            this.yesOnPressed();
          },
        ),
        new FlatButton(
          child: Text(this.no),
          onPressed: () {
            this.noOnPressed();
          },
        ),
      ],
    );
  }
}
