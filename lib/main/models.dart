import 'dart:math';
import '../app/models.dart';
import 'di/main_module.dart';

class Stripe {
  Point beginBottom;
  Point beginTop;
  Point endTop;
  Point endBottom;
  Stripe(
    {
      this.beginBottom,
      this.beginTop,
      this.endTop,
      this.endBottom,
    }
  ): assert(beginBottom != null),
  assert(beginTop != null),
  assert(endTop != null),
  assert(endBottom != null);
}

class SessionDigitConfig {
  double dialInnerRadius;
  double dialOuterRadius;

  SessionDigitConfig({this.dialInnerRadius,this.dialOuterRadius}):
    assert(dialInnerRadius > 0.0),
    assert(dialOuterRadius > dialInnerRadius);

  double delta() => dialOuterRadius - dialInnerRadius;
}

class SessionWidgetModel {

  Session session;
  int elapsed;
  SessionDigitConfig config;
  DateTime startTime;

  int totalLength() {
    if(session == null || session.sections == null || session.sections.length == 0) return 0;
    return session.sections 
                          .map((section) => section.length)
                          .reduce((collector,section){ collector += section; return collector;});}

   int totalLengthBefore(Section section) => session.sections.indexOf(section) == 0 ? 0 :
                                            session.sections
                                            .where((s)=> session.sections.indexOf(s) < session.sections.indexOf(section))
                                            .map((s)=> s.length)
                                            .reduce((collector,value)=> collector += value);

  double initRadius (Section section) => totalLengthBefore(section)*radiusDeduction();

  double endRadius (Section section) => session.sections
                                            .where((s)=> session.sections.indexOf(s) <= session.sections.indexOf(section))
                                            .map((s)=> s.length)
                                            .reduce((collector,value)=> collector += value)*radiusDeduction();

  double radiusDeduction() => config.delta()/totalLength();

  double angleBeforeSection (Section section) => (totalLengthBefore(section) + calculateStartRotation(startTime)) * MILLIS_TO_ANGLE;

  int calculateStartRotation(DateTime startTime) => (startTime.minute - 15) * 1000 * 60 + (startTime.second * 1000);
  
}