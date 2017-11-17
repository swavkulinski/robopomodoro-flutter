import 'package:Robopomodoro/main/dial/session_timer/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:Robopomodoro/main/dial/plate_widget/widget.dart';
import 'package:Robopomodoro/main/dial/session_prompt/widget.dart';
import 'package:Robopomodoro/main/dial/session_ends/widget.dart';

import 'package:Robopomodoro/main/dial/dial_painter.dart';
import 'package:Robopomodoro/main/digit/minute_digit.dart';
import 'package:Robopomodoro/main/digit/session_digit.dart';
import 'package:Robopomodoro/main/dial/toggle_button.dart';
import 'package:Robopomodoro/main/dial/round_button.dart';

import 'package:Robopomodoro/main/di/main_module.dart';
import 'package:Robopomodoro/main/models.dart';

class PomodoroWidget extends StatelessWidget {
  final Size size;
  final ScrollController scrollController;
  final SessionWidgetModel sessionWidgetModel;
  final ValueChanged<bool> onTapListener;
  
  PomodoroWidget({
    Key key,
    @required this.size,
    @required this.scrollController,
    @required this.sessionWidgetModel,
    @required this.onTapListener,
  });

  @override
  Widget build(BuildContext context)  =>

new Stack(children: <Widget>[
        new PlateWidget(size: size),
        //Add session prompt
        new SessionPrompt(
          size: size,
          scrollController: scrollController,
        ),
        //main linear layout
        new Padding(
            padding: new EdgeInsets.fromLTRB(
                0.0, DIAL_CENTER - DIAL_RADIUS, 0.0, 0.0),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //dial
                  _dial(),
                  new SectionTimer(sessionWidgetModel: sessionWidgetModel,),
                  new SessionEnds(
                    length: sessionWidgetModel.totalLength(),
                    sessionEnds: sessionWidgetModel.startTime.add(
                      new Duration(
                        milliseconds: sessionWidgetModel.totalLength(),
                      ),
                    ),
                  ),
                  new Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: new Text(
                        _getSessionState(),
                        style: currentTimeTextStyle,
                      ))
                ])),
      ]);
  
  String _getSessionState() =>  sessionWidgetModel.paused ? '' : 'SESSION IN PROGRESS';

   Widget _dial() => new Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: _dialElements(),
      );

  List<Widget> _dialElements() {
    var dial = <Widget>[
      new Center(
          child: new CustomPaint(
              size: new Size(DIAL_RADIUS * 2, DIAL_RADIUS * 2),
              painter: new DialPainter(
                platePaint: PomodoroPaints.fillFullWhite,
                tickPaint: PomodoroPaints.strokeGray80w1,
                tickLength: tickLength,
                dialColor: dialColor,
                shadowPaint: PomodoroPaints.shadowPaint,
              ))),
      new Center(
        child: new MinuteDigit(currentTime: sessionWidgetModel.currentTime, radius: DIAL_RADIUS),
      ),
    ];
    if (sessionWidgetModel.session != null) {
      dial.add(new Center(
          child: new SessionDigit(
        radius: DIAL_RADIUS,
        elapsedTime: sessionWidgetModel.elapsedTime(),
        startTime: sessionWidgetModel.startTime,
        sessionWidgetModel: sessionWidgetModel,
      )));
    }

    if (sessionWidgetModel.session != null) {
      dial.add(new Center(
          child: new ToggleButton(
              onStateChangeListener: (state) => onTapListener(state),
              state: sessionWidgetModel.paused,
              firstChild: new RoundButton(
                child: new Text(
                  "CANCEL",
                  style: defaultTextStyle,
                ),
                size: CENTRAL_BUTTON_SIZE,
                foregroundPaint: PomodoroPaints.fillFullWhite,
                shadowPaint: PomodoroPaints.shadowPaint,
              ),
              secondChild: new RoundButton(
                child: new Text(
                  "START",
                  style: defaultTextStyle,
                ),
                size: CENTRAL_BUTTON_SIZE,
                foregroundPaint: PomodoroPaints.fillFullWhite,
                shadowPaint: PomodoroPaints.shadowPaint,
              ))));
    }
    return dial;
  }

}