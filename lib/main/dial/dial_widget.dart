import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dial_painter.dart';
import '../di/main_module.dart';
import 'toggle_button.dart';
import 'round_button.dart';
import 'plate_widget.dart';
import 'snapping_scroll_physics.dart';
import '../digit/session_digit.dart';
import '../digit/minute_digit.dart';
import '../models.dart';
import '../session_state/session_state_delegate.dart';
import '../session_icon/session_icon.dart';
import '../../app/models.dart';
import 'dragable_icon/widget.dart';
import 'clear_schedule_button/widget.dart';
import 'session_ends/widget.dart';

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
                  _scheduleWidget(size),
                  _sessionIcons(size)
                ])))
      ],
    );
  }

  Widget _plate(size, scrollController, sessionState) =>
      new Stack(children: <Widget>[
        new PlateWidget(size: size),
        //Add session prompt
        _sessionPrompt(size, scrollController),
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

  Widget _sessionPrompt(size, scrollController) => new SizedBox(
      width: size.width,
      height: size.height,
      child: new Align(
          alignment: Alignment.bottomCenter,
          child: new Padding(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
              child: new GestureDetector(
                  onTap: () => scrollController.position.animateTo(size.height,
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 300)),
                  child: new Text(
                    "Add sessions",
                    style: defaultTextStyle,
                  )))));

  Widget _sessionEnds() {}

  Widget _sessionIcons(Size size) => new Column(children: [
        new Text(
          "Sessions",
          style: defaultTextStyle,
        ),
        new Container(
            width: size.width,
            height: 200.0,
            child: new GridView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              padding: new EdgeInsets.all(10.0),
              children: <Widget>[
                new DragableIcon(
                    session: sessionFactory.longPomodoro(), iconSize: iconSize),
                new DragableIcon(
                    session: sessionFactory.shortPomodoro(),
                    iconSize: iconSize),
                new DragableIcon(
                    session: sessionFactory.firstCoffee(), iconSize: iconSize),
                new DragableIcon(
                    session: sessionFactory.secondCoffee(), iconSize: iconSize),
                new DragableIcon(
                    session: sessionFactory.thirdCoffee(), iconSize: iconSize),
              ],
            ))
      ]);

  Widget _scheduleWidget(Size size) =>
      new DragTarget<Session>(onWillAccept: (session) {
        return true;
      }, onAccept: (session) {
        sessionController.add(session);
      }, builder: (context, candidate, rejected) {
        return new Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 36.0, 8.0, 0.0),
          child: new Card(
            child: new Column(children: [
              new Text(
                _yourScheduleEnds(),
                style: defaultTextStyle,
              ),
              new Stack(
                children: <Widget>[
                  new Container(
                      constraints: new BoxConstraints.loose(
                          new Size(size.width, size.height / 2)),
                      child: new GridView(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          children: _createScheduleWidgets())),
                  new Container(
                    constraints: new BoxConstraints.loose(
                        new Size(size.width, size.height / 2)),
                    child: new Align(
                      alignment: new Alignment(0.0, 1.0),
                      child: new ClearScheduleButton(
                          callback: () => sessionController.clearSchedule()),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      });

  List<Widget> _createScheduleWidgets() {
    var list = new List();
    for (Session session in sessionController.getSchedule()) {
      list.add(
        new Padding(
            padding: Paddings.ALL_8,
            child: new SessionIcon(
              session: session,
              size: iconSize,
              shadowPaint: PomodoroPaints.shadowPaint,
            )),
      );
    }
    return list;
  }

  String _yourScheduleEnds() {
    if (sessionController.getSchedule() == null ||
        sessionController.getSchedule().length == 0) {
      return "Your schedule";
    } else {
      var scheduleEnd = currentTimeFormat.format(startTime.add(new Duration(
          milliseconds: sessionController
              .getSchedule()
              .map((session) => session.length())
              .reduce((i, c) => i += c))));
      return "Your schedule ends $scheduleEnd";
    }
  }
}
