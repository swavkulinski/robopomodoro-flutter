import 'package:flutter/material.dart';
import 'dart:async';
import 'dial/dial_widget.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => new _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  var elapsedTime = 0;
  bool isPaused = true;
  DateTime currentTime;
  DateTime startTime;

  @override
  void initState() {
    startTime = new DateTime.now();
    currentTime = new DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      new Future.delayed(
        new Duration(milliseconds: 100))
        .whenComplete(()=> setState(() {
          if(!isPaused) {
            elapsedTime +=100;
          }
          currentTime = new DateTime.now();
        }),
      );
    return new DialWidget(
      elapsedTime: elapsedTime,
      onTapListener: _handleOnTap,
      paused: isPaused,
      currentTime: currentTime,
      startTime: startTime,
    );
  }

  void _handleOnTap () => setState((){
    isPaused = !isPaused;
    startTime = new DateTime.now();
  });
}
