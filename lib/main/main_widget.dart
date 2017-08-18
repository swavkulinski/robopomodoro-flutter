import 'package:flutter/material.dart';
import 'dart:async';
import 'dial/dial_widget.dart';
import 'di/main_module.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => new _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  bool isPaused = true;
  DateTime currentTime;
  DateTime startTime;
  DateTime lastTime;

  int wrap = 1000;

  @override
  void initState() {
    startTime = timeProvider();
    currentTime = timeProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      new Future.delayed(
        new Duration(milliseconds: 1000))
        .whenComplete(()=> setState(() {
          if(!isPaused) {
        //    elapsedTime +=100;
          }
          currentTime = timeProvider(); 
        }),
      );
    return new DialWidget(
      elapsedTime: currentTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch,
      onTapListener: _handleOnTap,
      paused: isPaused,
      currentTime: currentTime,
      startTime: startTime,
    );
  }

  void _handleOnTap () => setState((){
    isPaused = !isPaused;
    startTime = timeProvider(); 
  });
}
