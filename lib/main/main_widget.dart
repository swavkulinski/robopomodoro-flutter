import 'package:flutter/material.dart';
import 'dart:async';
import 'dial_widget.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => new _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  var elapsedTime = 0;
  bool isPaused = true;
  int minute = 0;

  @override
  Widget build(BuildContext context) {
      new Future.delayed(
        new Duration(milliseconds: 100))
        .whenComplete(()=> setState(() {
          if(!isPaused) {
            elapsedTime +=100;
          }
          minute = new TimeOfDay.now().minute;
        }),
      );
    return new DialWidget(
      elapsedTime: elapsedTime,
      onTapListener: _handleOnTap,
      paused: isPaused,
      minute: minute,
    );
  }

  void _handleOnTap () => setState(()=> isPaused = !isPaused);
}
