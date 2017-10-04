import 'package:flutter/material.dart';
import 'dart:async';
import 'dial/dial_widget.dart';
import 'di/main_module.dart';
import 'models.dart';
import '../app/models.dart';
import 'session_controller/session_controller.dart';

class MainWidget extends StatefulWidget {

  MainWidget();

  @override
  _MainWidgetState createState() => new _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  bool isPaused = true;
  DateTime currentTime;
  DateTime startTime;
  DateTime lastTime;
  SessionController sc;

  bool isScheduling = false;
  _MainWidgetState() {
    sc = sessionController;
    sc.onChange = _controllerOnChangeHandler();
    print(sc == null);
  }


  SessionDigitConfig sessionDigitConfig() => new SessionDigitConfig(dialOuterRadius : 135.0,dialInnerRadius : 50.0);
  SessionWidgetModel sessionWidgetModel(Session session) => new SessionWidgetModel()
              ..startTime = startTime
              ..session = session              
              ..config = sessionDigitConfig()
              ..elapsed = currentTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;
  
  @override
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
              if(sessionWidgetModel(sc.getCurrentSession()).session == null) {
                isPaused = true;
                startTime = currentTime;
              }
              if(isPaused) {
                startTime = startTime.add(new Duration(milliseconds: newTime.millisecondsSinceEpoch - currentTime.millisecondsSinceEpoch));
              }
              currentTime = newTime;
              isScheduling = false;
              sc.updateSession(startTime,currentTime);
            }),
      );
 
      }
      return new DialWidget(
      elapsedTime: currentTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch,
      onTapListener: _handleOnTap,
      paused: isPaused,
      currentTime: currentTime,
      startTime: startTime,
      sessionWidgetModel: sessionWidgetModel(sc.getCurrentSession()),
      sessionController: sc,
    );
  }

  void _handleOnTap () => setState((){
    isPaused = !isPaused;
    startTime = currentTime;
  });

  VoidCallback _controllerOnChangeHandler() {
    return () => setState(() => print("SessionController change"));
  }
}
