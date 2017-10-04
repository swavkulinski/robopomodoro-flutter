import 'package:flutter/material.dart';
import 'dial_painter.dart';
import '../di/main_module.dart';
import 'central_button.dart';
import '../digit/session_digit.dart';
import '../digit/minute_digit.dart';
import '../models.dart';
import '../session_controller/session_controller.dart';

class DialWidget extends StatelessWidget {
  static const DIAL_CENTER = 200.0;
  static const DIAL_RADIUS = 140.0;
  static const DEFAULT_COLOR = 0xFFA4C639;
  static const double radius = 45.0;
  final int elapsedTime;
  final VoidCallback onTapListener;
  final bool paused;
  final DateTime currentTime;
  final DateTime startTime;
  final SessionWidgetModel sessionWidgetModel;
  final SessionController sessionController;

  DialWidget({
    this.elapsedTime,
    this.onTapListener,
    this.paused,
    this.currentTime,
    this.startTime,
    this.sessionWidgetModel,
    this.sessionController,
  })
      : assert(onTapListener != null);

  Widget build(BuildContext context) {
    var sessionState = paused ? '' : 'Session in progress';
    var dial = <Widget>[
      new Center(
          child: new CustomPaint(
              size: new Size(DIAL_RADIUS * 2, DIAL_RADIUS * 2),
              painter: new DialPainter(
                platePaint: platePaint(),
                dialColor: dialColor,
                shadowPaint: defaultShadowPaint(),
              ))),
      new Center(
        child: new MinuteDigit(currentTime: currentTime, radius: DIAL_RADIUS),
      ),
    ];
    if (sessionWidgetModel.session != null) {
      dial.add(new SessionDigit(
        radius: DIAL_RADIUS,
        elapsedTime: elapsedTime,
        startTime: startTime,
        sessionWidgetModel: sessionWidgetModel,
      ));
    }
    //TODO investigate why I have to add central button on the end. SessionDigit intercepts clicks even if it doesn't have gesture detector
    dial.add(new Center(
        child: new CentralButton(
      onTapListener: onTapListener,
      radius: radius,
      paused: paused,
      noSession: sessionWidgetModel.session == null,
    )));

    var children = <Widget>[
      //background
      new Container(
        color: platePaint().color,
      ),
      //main linear layout
      new Padding(
          padding:
              new EdgeInsets.fromLTRB(0.0, DIAL_CENTER - DIAL_RADIUS, 0.0, 0.0),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //dial
                new Stack(
                  alignment: FractionalOffsetDirectional.center,
                  children: dial,
                ),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: new Text(
                    sessionTimeFormat.format(
                        new DateTime.fromMillisecondsSinceEpoch(elapsedTime)),
                    style: sessionTimeTextStyle,
                  ),
                ),
                new Text(
                  currentTimeFormat.format(new DateTime.now()),
                  style: currentTimeTextStyle,
                ),
                new Padding(
                    padding: new EdgeInsets.all(8.0),
                    child: new Text(
                      sessionState,
                      style: currentTimeTextStyle,
                    ))
              ])),

      //session buttons
      new Align(
          alignment: new FractionalOffset(0.0, 1.0),
          child: new Material(
            child: new ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                    onPressed: () =>
                        sessionController.add(sessionFactory.longPomodoro()),
                    child: new Text('Add Long')),
                new FlatButton(
                    onPressed: () =>
                        sessionController.add(sessionFactory.shortPomodoro()),
                    child: new Text('Add Short')),
                new FlatButton(
                    onPressed: () => sessionController.clearSchedule(),
                    child: new Text('Clear')),
              ],
            ),
          ))
    ];

    //session digit

    return new Stack(children: children);
  }
}
