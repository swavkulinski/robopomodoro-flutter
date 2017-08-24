import '../../app/models.dart';
import '../di/main_module.dart';

class SessionController {




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
        ..length = length,
    ];
}