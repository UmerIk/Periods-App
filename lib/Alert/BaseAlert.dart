import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {

  //When creating please recheck 'context' if there is an error!

  late String _title;
  late String _content;
  late String _yes;
  late String _no;
  late Function _yesOnPressed;
  late Function _noOnPressed;

  BaseAlertDialog({required String title, required String content, required Function yesOnPressed, required Function noOnPressed, String yes = "Yes", String no = "No"}){
    this._title = title;
    this._content = content;
    this._yesOnPressed = yesOnPressed;
    this._noOnPressed = noOnPressed;
    this._yes = yes;
    this._no = no;
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? AndroidAlert() : IOSAlert();
  }

  CupertinoAlertDialog IOSAlert() {
    return CupertinoAlertDialog(
      title: new Text(this._title ,),
      content: new Text(this._content ),

      actions: <Widget>[
        new CupertinoDialogAction(
          child: new Text(this._yes),
          onPressed: () {
            this._yesOnPressed();
          },
        ),
        new CupertinoDialogAction(
          child: Text(this._no),
          onPressed: () {
            this._noOnPressed();
          },
        ),
      ],
    );
  }
  AlertDialog AndroidAlert() {
    return AlertDialog(
    title: new Text(this._title ),
    content: new Text(this._content ),

    actions: <Widget>[
      new FlatButton(
        child: new Text(this._yes,),
        onPressed: () {
          this._yesOnPressed();
        },
      ),
      new FlatButton(
        child: Text(this._no ,),
        onPressed: () {
          this._noOnPressed();
        },
      ),
    ],
  );
  }
}