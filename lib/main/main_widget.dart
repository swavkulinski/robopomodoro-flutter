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

  @override
  Widget build(BuildContext context) {
    if(!isPaused){
      new Future.delayed(new Duration(milliseconds: 100)).whenComplete(()=> setState(()=> elapsedTime +=100));
    }
    return new DialWidget(elapsedTime: elapsedTime,onTapListener: _handleOnTap);
  }

  void _handleOnTap () => setState(()=> isPaused = !isPaused);
}
