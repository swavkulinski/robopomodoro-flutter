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
import '../../app/models.dart';

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
    var size = MediaQuery.of(context).size;
    var sessionState = paused ? '' : 'SESSION IN PROGRESS';
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

    dial.add(
      new Align(
          alignment: new FractionalOffset(1.0, 1.0),
          widthFactor: 5.3,
          heightFactor: 5.3,
          child: new GestureDetector(
              onTap: () => sessionController.clearSchedule(),
              child: new RoundButton(
                child: new Icon(Icons.delete),
                size: new Size(60.0, 60.0),
                foregroundPaint: platePaint(),
                shadowPaint: defaultShadowPaint(),
              ))),
    );

    if (sessionWidgetModel.session != null) {
      dial.add(new Center(
          child: new ToggleButton(
              onStateChangeListener: (state) => onTapListener(state),
              state: paused,
              firstChild: new RoundButton(
                child: new Text(
                  "CANCEL",
                  style: defaultTextStyle,
                ),
                size: CENTRAL_BUTTON_SIZE,
                foregroundPaint: platePaint(),
                shadowPaint: defaultShadowPaint(),
              ),
              secondChild: new RoundButton(
                child: new Text(
                  "START",
                  style: defaultTextStyle,
                ),
                size: CENTRAL_BUTTON_SIZE,
                foregroundPaint: platePaint(),
                shadowPaint: defaultShadowPaint(),
              ))));
    }

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
          child: new ConstrainedBox(
            constraints: new BoxConstraints.loose(new Size(size.width, 100.0)),
            child: new ListView(
              physics: new BouncingScrollPhysics(),
              padding: new EdgeInsets.all(10.0),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _createIcon(sessionFactory.longPomodoro()),
                _createIcon(sessionFactory.shortPomodoro()),
                _createIcon(sessionFactory.firstCoffee()),
                _createIcon(sessionFactory.secondCoffee()),
                _createIcon(sessionFactory.thirdCoffee()),
              ],
            ),
          ))
    ];

    //session digit

    return new Stack(children: children);
  }

  Widget _createIcon(Session session) {
    return new Padding(
        padding: PADDING_24,
        child: new SessionIcon(
            session: session,
            size: iconSize,
            onClick: () => sessionController.add(session)));
  }
}
