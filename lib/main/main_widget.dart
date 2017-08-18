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

  bool isScheduling = false;

  
  void initState() {
    startTime = timeProvider();
    currentTime = startTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      if(!isScheduling) {
          isScheduling = true;
          new Future.delayed(
            new Duration(milliseconds: 1000))
            .whenComplete(()=> setState(() {
              var newTime = timeProvider();
              if(isPaused) {
                startTime = startTime.add(new Duration(milliseconds: newTime.millisecondsSinceEpoch - currentTime.millisecondsSinceEpoch));
              }
              currentTime = newTime;
              isScheduling = false; 
            }),
      );
 
      }
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
    startTime = currentTime; 
  });
}
