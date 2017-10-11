import 'package:flutter/material.dart';
import 'dial_painter.dart';
import '../di/main_module.dart';
import 'toggle_button.dart';
import 'round_button.dart';
import '../digit/session_digit.dart';
import '../digit/minute_digit.dart';
import '../models.dart';
import '../session_state/session_state_delegate.dart';
import '../session_icon/session_icon.dart';

class DialWidget extends StatelessWidget {
  static const DIAL_CENTER = 200.0;
  static const DIAL_RADIUS = 140.0;
  static const DEFAULT_COLOR = 0xFFA4C639;
  static const double radius = 45.0;
  static const CENTRAL_BUTTON_SIZE = const Size(90.0, 90.0);
  final int elapsedTime;
  final ValueChanged<bool> onTapListener;
  final bool paused;
  final DateTime currentTime;
  final DateTime startTime;
  final SessionWidgetModel sessionWidgetModel;
  final SessionStateDelegate sessionController;
  final Size iconSize;

  DialWidget({
    this.elapsedTime,
    this.onTapListener,
    this.paused,
    this.currentTime,
    this.startTime,
    this.sessionWidgetModel,
    this.sessionController,
    this.iconSize,
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
                tickPaint: tickDialPaint,
                tickLength: tickLength,
                dialColor: dialColor,
                shadowPaint: defaultShadowPaint(),
              ))),
      new Center(
        child: new MinuteDigit(currentTime: currentTime, radius: DIAL_RADIUS),
      ),
    ];
    if (sessionWidgetModel.session != null) {
      dial.add(new Center(
          child: new SessionDigit(
        radius: DIAL_RADIUS,
        elapsedTime: elapsedTime,
        startTime: startTime,
        sessionWidgetModel: sessionWidgetModel,
      )));
    }
    //TODO investigate why I have to add central button on the end. SessionDigit intercepts clicks even if it doesn't have gesture detector
    
    dial.add(
      new Align(
          alignment: new FractionalOffset(1.0, 1.0),
          widthFactor: 5.1,
          heightFactor: 5.1,
          child: new GestureDetector(
              onTap: () => sessionController.clearSchedule(),
              child: new RoundButton(
                child: new Icon(Icons.delete),
                size: new Size(60.0, 60.0),
                foregroundPaint: platePaint(),
                shadowPaint: defaultShadowPaint(),
              ))),
    );
    dial.add(new Center(
        child: new ToggleButton(
      onStateChangeListener: (state) => onTapListener(state),
      state: paused,
      firstChild: new RoundButton(
        child: new Text(
          "Cancel",
          style: defaultTextStyle,
        ),
        size: CENTRAL_BUTTON_SIZE,
        foregroundPaint: platePaint(),
        shadowPaint: defaultShadowPaint(),
      ),
      secondChild: new RoundButton(
        child: new Text(
          "Start",
          style: defaultTextStyle,
        ),
        size: CENTRAL_BUTTON_SIZE,
        foregroundPaint: platePaint(),
        shadowPaint: defaultShadowPaint(),
      ),
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
                  fit: StackFit.passthrough,
                  alignment: FractionalOffsetDirectional.center,
                  children: dial,
                ),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: new Text(
                    sessionTimeFormat.format(
                        new DateTime.fromMillisecondsSinceEpoch(
                            sessionWidgetModel.totalLength() - elapsedTime)),
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
                new Padding(
                  padding: new EdgeInsets.all(6.0),
                  child: new SessionIcon(
                      session: sessionFactory.longPomodoro(),
                      size: iconSize,
                      onClick: () =>
                          sessionController.add(sessionFactory.longPomodoro())),
                ),
                new SessionIcon(
                    session: sessionFactory.shortPomodoro(),
                    size: iconSize,
                    onClick: () =>
                        sessionController.add(sessionFactory.shortPomodoro())),
                new SessionIcon(
                    session: sessionFactory.firstCoffee(),
                    size: iconSize,
                    onClick: () =>
                        sessionController.add(sessionFactory.firstCoffee())),
                new SessionIcon(
                    session: sessionFactory.secondCoffee(),
                    size: iconSize,
                    onClick: () =>
                        sessionController.add(sessionFactory.secondCoffee())),
                new SessionIcon(
                    session: sessionFactory.thirdCoffee(),
                    size: iconSize,
                    onClick: () =>
                        sessionController.add(sessionFactory.thirdCoffee())),
              ],
            ),
          ))
    ];

    //session digit

    return new Stack(children: children);
  }
}
