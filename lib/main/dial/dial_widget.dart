import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dial_painter.dart';
import '../di/main_module.dart';
import 'toggle_button.dart';
import 'round_button.dart';
import 'schedule_widget.dart';
import 'plate_widget.dart';
import '../digit/session_digit.dart';
import '../digit/minute_digit.dart';
import '../models.dart';
import '../session_state/session_state_delegate.dart';
import '../session_icon/session_icon.dart';
import '../../app/models.dart';

import 'dart:math' as math;

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

    var scrollController = new ScrollController();
    var plate = <Widget>[
      //background
      new Container(
        color: platePaint().color,
      ),
      new PlateWidget(size: size),
      //Add session prompt
      new SizedBox(
          width: size.width,
          height: size.height,
          child: new Align(
              alignment: Alignment.bottomCenter,
              child: new Padding(
                  padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
                  child: new GestureDetector(
                    onTap: ()=>scrollController.position.animateTo(size.height,curve: Curves.easeIn,duration: const Duration(milliseconds: 300)),
                    child:new Text("Add sessions",style: defaultTextStyle,))))),
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
                  alignment: Alignment.center,
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
                  _sessionEnds(),
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
      new Align(alignment: Alignment.bottomCenter, child: _bottomSlate(size))
    ];

    //session digit
    return new CustomScrollView(
      controller: scrollController,
      physics: new _SnappingScrollPhysics(maxScrollOffset: size.height),
      slivers: <Widget>[
        new SliverToBoxAdapter(
            child: new Container(
          width: size.width,
          height: size.height * 2,
          child: new Stack(children: plate),
        ))
      ],
    );
  }

  String _sessionEnds() {
    if(sessionWidgetModel.totalLength() > 0) {
      return "Session ends ${currentTimeFormat.format(sessionWidgetModel.startTime.add(new Duration(milliseconds:sessionWidgetModel.totalLength())))}";
    }
    return "";
  }

  Widget _bottomSlate(Size size) => new Align(
      alignment: Alignment.bottomCenter,
      child: new Container(
        width: size.width,
        height: 300.0,
        child: new Column(
          children: <Widget>[_scheduleWidget(size), _sessionIcons(size)],
        ),
      ));

  Widget _sessionIcons(Size size) => new Container(
      width: size.width,
      height: 200.0,
      child:
          //TODO Grid
          new GridView(
        scrollDirection: Axis.vertical,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        physics: new BouncingScrollPhysics(),
        padding: new EdgeInsets.all(10.0),
        children: <Widget>[
          _createIcon(sessionFactory.longPomodoro()),
          _createIcon(sessionFactory.shortPomodoro()),
          _createIcon(sessionFactory.firstCoffee()),
          _createIcon(sessionFactory.secondCoffee()),
          _createIcon(sessionFactory.thirdCoffee()),
        ],
      ));

  Widget _scheduleWidget(Size size) => new Expanded(
      child: new OverflowBox(
          alignment: Alignment.centerLeft,
          maxWidth: size.width + 200,
          maxHeight: 100.0,
          child: new ScheduleWidget(
            painter: new PillPainter(pillPaint: schedulePillPaint),
            size: new Size(size.width, 100.0),
          )));

  Widget _createIcon(Session session) {
    return new Padding(
        padding: PADDING_24,
        child: new SessionIcon(
            session: session,
            size: iconSize,
            onClick: () => sessionController.add(session)));
  }
}

class _SnappingScrollPhysics extends ScrollPhysics {
  const _SnappingScrollPhysics({
    ScrollPhysics parent,
    @required this.maxScrollOffset,
  })
      : assert(maxScrollOffset != null),
        super(parent: parent);

  final double maxScrollOffset;

  @override
  _SnappingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return new _SnappingScrollPhysics(
        parent: buildParent(ancestor), maxScrollOffset: maxScrollOffset);
  }

  Simulation _toMaxScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return new ScrollSpringSimulation(spring, offset, maxScrollOffset, velocity,
        tolerance: tolerance);
  }

  Simulation _toZeroScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return new ScrollSpringSimulation(spring, offset, 0.0, velocity,
        tolerance: tolerance);
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double dragVelocity) {
    final Simulation simulation =
        super.createBallisticSimulation(position, dragVelocity);
    final double offset = position.pixels;

    if (simulation != null) {
      // The drag ended with sufficient velocity to trigger creating a simulation.
      // If the simulation is headed up towards midScrollOffset but will not reach it,
      // then snap it there. Similarly if the simulation is headed down past
      // midScrollOffset but will not reach zero, then snap it to zero.
      final double simulationEnd = simulation.x(maxScrollOffset);
      if (simulationEnd >= maxScrollOffset) return simulation;
      if (dragVelocity > 0.0)
        return _toMaxScrollOffsetSimulation(offset, dragVelocity);
      if (dragVelocity < 0.0)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    } else {
      // The user ended the drag with little or no velocity. If they
      // didn't leave the the offset above midScrollOffset, then
      // snap to midScrollOffset if they're more than halfway there,
      // otherwise snap to zero.
      final double snapThreshold = maxScrollOffset / 2.0;
      if (offset >= snapThreshold && offset < maxScrollOffset)
        return _toMaxScrollOffsetSimulation(offset, dragVelocity);
      if (offset > 0.0 && offset < snapThreshold)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    }
    return simulation;
  }
}
