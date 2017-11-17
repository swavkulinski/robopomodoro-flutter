import 'package:flutter/material.dart';
import 'di/main_module.dart';
import 'models.dart';
import 'session_state/session_state_delegate.dart';

class MainWidget extends StatefulWidget {

  MainWidget();

  @override
  _MainWidgetState createState() => new _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  //bool isPaused = true;
    SessionStateDelegate sc = new SessionStateDelegate();

  //bool isScheduling = false;

  _MainWidgetState() {
    sc.sessionDigitConfig = sessionDigitConfig();
    sc.onChange = _controllerOnChangeHandler();
    print(sc == null);
  }

  SessionDigitConfig sessionDigitConfig() => new SessionDigitConfig(dialOuterRadius : 135.0,dialInnerRadius : 50.0);
  @override
  void initState() {
    sc.startTime = timeProvider();
    sc.currentTime = sc.startTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      
      //TODO move tick to delegate
      sc.build();
      
      return sc.getDialWidget();
  }

  VoidCallback _controllerOnChangeHandler() {
    return () => setState(() {});
  }
}
