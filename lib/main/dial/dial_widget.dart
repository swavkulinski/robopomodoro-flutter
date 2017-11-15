import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dial_painter.dart';
import '../di/main_module.dart';
import 'toggle_button.dart';
import 'round_button.dart';
import 'plate_widget/widget.dart';
import 'snapping_scroll_physics.dart';
import '../digit/session_digit.dart';
import '../digit/minute_digit.dart';
import '../models.dart';
import '../session_state/session_state_delegate.dart';
import 'session_prompt/widget.dart';
import 'session_ends/widget.dart';
import 'session_icons_grid/widget.dart';
import 'schedule_widget/widget.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

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

    var scrollController = new ScrollController();

    //session digit
    return new CustomScrollView(
      controller: scrollController,
      physics: new SnappingScrollPhysics(maxScrollOffset: size.height),
      slivers: <Widget>[
        new SliverToBoxAdapter(
            child: new Container(
                decoration: new BoxDecoration(color: platePaint().color),
                width: size.width,
                height: size.height * 2,
                child: new Column(children: <Widget>[
                  _plate(size, scrollController, sessionState),
                  new ScheduleWidget(
                    sessionController: sessionController,
                    size: size,
                    iconSize: iconSize,
                    scheduleEnds: _calculateSessionEnds(
                      sessionStarts: sessionWidgetModel.startTime,
                      milliseconds: sessionWidgetModel.totalLength(),
                    ),
                  ),
                  new SessionIconsGrid(
                    size: size,
                    iconSize: iconSize,
                  ),
                ])))
      ],
    );
  }

  DateTime _calculateSessionEnds({DateTime sessionStarts, int milliseconds}) =>
      sessionStarts.add(new Duration(milliseconds: milliseconds));

  Widget _plate(size, scrollController, sessionState) =>
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
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                    child: new Text(
                      sessionTimeFormat.format(
                          new DateTime.fromMillisecondsSinceEpoch(
                              sessionWidgetModel.totalLength() - elapsedTime)),
                      style: sessionTimeTextStyle,
                    ),
                  ),
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
                        sessionState,
                        style: currentTimeTextStyle,
                      ))
                ])),
      ]);

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
                platePaint: platePaint(),
                tickPaint: PomodoroPaints.strokeGray80w1,
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
    return dial;
  }
}
