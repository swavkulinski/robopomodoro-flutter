import '../../app/models.dart';
import '../di/main_module.dart';

SessionFactory sessionFactory = new SessionFactory();
SessionController sessionController = new SessionController();

class SessionController {

    List<Session> _schedule = <Session>[];
    

    List<Session> getSchedule() => _schedule;

    Session getCurrentSession() { if(_schedule.length > 0) {
      return _schedule[0];
    } else {
      return null;
    }}

    void removeSession(int index) => _schedule.removeAt(index);

    void clearSchedule() => _schedule.clear();

    void add(Session value) => _schedule.add(value);

    void addAt(Session value, int index) => _schedule.insertAll(index, [value]);

    void move({int from, int to}) { 
      Session fromSession = _schedule[from];
      Session toSession = _schedule[to];
      _schedule[from] = toSession;
      _schedule[to] = fromSession;
    }

    void pop() => _schedule.removeAt(0);
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