import '../../app/models.dart';
import '../di/main_module.dart';
import 'dart:ui';

SessionFactory sessionFactory = new SessionFactory();
SessionController sessionController = new SessionController();

class SessionController {

    VoidCallback onChange;

    List<Session> _schedule = <Session>[sessionFactory.longPomodoro()];

    List<Session> getSchedule() => _schedule;

    Session getCurrentSession() { if(_schedule.length > 0) {
      return _schedule[0];
    } else {
      return null;
    }}

    void removeSession(int index) {_schedule.removeAt(index); onChange();} 

    void clearSchedule() {_schedule.clear(); onChange();}

    void add(Session value) {_schedule.add(value); onChange();}

    void addAt(Session value, int index) {_schedule.insertAll(index, [value]);onChange();}

    void move({int from, int to}) { 
      Session fromSession = _schedule[from];
      Session toSession = _schedule[to];
      _schedule[from] = toSession;
      _schedule[to] = fromSession;
      onChange();
    }

    void pop() {_schedule.removeAt(0);onChange();}
}

class SessionFactory {

  Session shortPomodoro() => _pomodoro(25, 5, 'Short Pomodoro'); 
  Session longPomodoro() => _pomodoro(25, 15, 'Long Pomodoro'); 

  Session firstCoffee() => _coffee(8,'First coffee');
  Session secondCoffee() => _coffee(5,'Second coffee');
  Session thirdoffee() => _coffee(3,'Third coffee');

  Session _pomodoro(workSectionLength,breakSectionLength, name) => new Session()
    ..name = name
    ..sections = <Section> [
      new Section()
        ..backgroundPaint = workSectionIncompletePaint
        ..foregroundPaint = workSectionCompletePaint
        ..length = workSectionLength * 60 * 1000,
      new Section()
        ..backgroundPaint = breakSectionIncompletePaint
        ..foregroundPaint = breakSectionCompletePaint
        ..length = breakSectionLength * 60 * 1000
    ];


  Session _coffee(length,name) => new Session()
    ..name = name
    ..sections = <Section>[
      new Section()
        ..backgroundPaint = workSectionIncompletePaint
        ..foregroundPaint = workSectionCompletePaint
        ..length = length * 60 * 1000,
    ];
}