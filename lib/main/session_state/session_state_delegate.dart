import 'package:flutter/material.dart';
import '../../app/models.dart';
import '../di/main_module.dart';
import '../dial/dial_widget.dart';
import '../../main/models.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

const SessionFactory sessionFactory = const SessionFactory();

class SessionStateDelegate {

  VoidCallback onChange;

  SessionDigitConfig sessionDigitConfig;

  List<Session> _schedule = <Session>[sessionFactory.longPomodoro()];

  List<Session> getSchedule() => _schedule;

  bool isScheduling = false;
  bool isPaused = true;

  DateTime currentTime;
  DateTime startTime;
  DateTime lastTime;

  Session getCurrentSession() {
    if (_schedule.length > 0) {
      return _schedule[0];
    } else {
      return null;
    }
  }

  void removeSession(int index) {
    _schedule.removeAt(index);
    onChange();
  }

  void clearSchedule() {
    _schedule.clear();
    onChange();
  }

  void add(Session value) {
    _schedule.add(value);
    onChange();
  }

  void addAt(Session value, int index) {
    _schedule.insertAll(index, [value]);
    onChange();
  }

  void move({int from, int to}) {
    Session fromSession = _schedule[from];
    Session toSession = _schedule[to];
    _schedule[from] = toSession;
    _schedule[to] = fromSession;
    onChange();
  }

  void pop() {
    _schedule.removeAt(0);
    onChange();
  }

  void build() {
    if (!isScheduling) {
      isScheduling = true;
      new Future.delayed(new Duration(milliseconds: REFRESH_TIME_MILLISECONDS))
          .whenComplete(() {
        var newTime = timeProvider();
        if (sessionWidgetModel(sessionDigitConfig).session == null) {
          isPaused = true;
          startTime = currentTime;
        }
        if (isPaused) {
          startTime = startTime.add(new Duration(
              milliseconds: newTime.millisecondsSinceEpoch -
                  currentTime.millisecondsSinceEpoch));
        }
        currentTime = newTime;
        isScheduling = false;
        updateSession();
        onChange();
      });
    }
  }

  void updateSession() {
    Session session = getCurrentSession();
    if (session != null) {
      var usedTime = currentTime.millisecondsSinceEpoch -startTime.millisecondsSinceEpoch;
      

      if (usedTime > session.length()) {
        HapticFeedback.vibrate();
        startTime = currentTime;
        getCurrentSession().currentSection(min(usedTime,session.length())).signalOnEnd = false;
        pop();
        print("popping session, remaining sessions:${_schedule.length}");
      } else if (session.currentSection(min(usedTime,session.length())).signalOnStart) {
        session.currentSection(usedTime).signalOnStart = false;
        HapticFeedback.vibrate();
      }
    }
  }

  Widget getDialWidget() {
    return new DialWidget(
            onTapListener: _handlePauseResumeOnTap,
      sessionWidgetModel: sessionWidgetModel(sessionDigitConfig),
      sessionController: this,
      iconSize: new Size.fromRadius(30.0),
    );
  }

  void _handlePauseResumeOnTap(bool state) {
    print("_handlePauseResumeOnTap($state)");
    isPaused = state;
    startTime = currentTime;
    if(state){
      pop();
    }
    onChange();
  }

  SessionWidgetModel sessionWidgetModel(
          SessionDigitConfig sessionDigitConfig) =>
      new SessionWidgetModel()
        ..startTime = startTime
        ..currentTime = currentTime
        ..session = getCurrentSession()
        ..paused = isPaused
        ..config = sessionDigitConfig;
}

class SessionFactory {
  const SessionFactory();

  Session shortPomodoro() => _pomodoro(25, 5, 'Short Pomodoro','25\' work + 5\' break');
  Session longPomodoro() => _pomodoro(25, 15, 'Long Pomodoro', '25\' work + 15\' break');

  Session firstCoffee() => _coffee(8, 'First coffee', '8\' discussion');
  Session secondCoffee() => _coffee(5, 'Second coffee', '5\' discussion');
  Session thirdCoffee() => _coffee(3, 'Third coffee', '3\' discussion');

  Session _pomodoro(workSectionLength, breakSectionLength, name, description) =>
      new Session()
        ..description = description
        ..name = name
        ..sections = <Section>[
          new Section()
            ..backgroundPaint = PomodoroPaints.fillSemiWork
            ..foregroundPaint = PomodoroPaints.fillFullWork 
            ..length = workSectionLength * 60 * 1000,
          new Section()
            ..backgroundPaint = PomodoroPaints.fillSemiRecess
            ..foregroundPaint = PomodoroPaints.fillFullRecess
            ..length = breakSectionLength * 60 * 1000
            ..signalOnStart = true
            ..signalOnEnd = true,
        ];

  Session _coffee(length, name, description) => new Session()
    ..name = name
    ..description = description
    ..sections = <Section>[
      new Section()
        ..backgroundPaint = PomodoroPaints.fillSemiWork
        ..foregroundPaint = PomodoroPaints.fillFullWork 
        ..length = length * 60 * 1000
        ..signalOnEnd = true,
    ];
}
