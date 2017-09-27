import 'package:flutter/material.dart';
import 'dart:async';
import 'dial/dial_widget.dart';
import 'di/main_module.dart';
import 'digit/models.dart';
import 'session_controller/session_controller.dart';

class MainWidget extends StatefulWidget {

  final SessionController sessionController = new SessionController();

  MainWidget();

  @override
  _MainWidgetState createState() => new _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  bool isPaused = true;
  DateTime currentTime;
  DateTime startTime;
  DateTime lastTime;

  bool isScheduling = false;
  _MainWidgetState();


  SessionDigitConfig sessionDigitConfig() => new SessionDigitConfig(dialOuterRadius : 135.0,dialInnerRadius : 50.0);
  SessionWidgetModel sessionWidgetModel() => new SessionWidgetModel()
              ..startTime = startTime
              ..session = sessionController.getCurrentSession()              
              ..config = sessionDigitConfig()
              ..elapsed = currentTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;
  
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
            new Duration(milliseconds: REFRESH_TIME_MILLISECONDS))
            .whenComplete(()=> setState(() {
              var newTime = timeProvider();
              if(sessionWidgetModel().session == null) {
                isPaused = true;
                startTime = currentTime;
              }
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
      sessionWidgetModel: sessionWidgetModel(),
    );
  }

  void _handleOnTap () => setState((){
    isPaused = !isPaused;
    startTime = currentTime;
    if(isPaused && sessionWidgetModel().session != null) {
      sessionController.pop(); 
    }
  });
}
