import 'dart:math';
import '../../app/models.dart';
import '../di/main_module.dart';

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

  List<Section> sections;
  int elapsed;
  SessionDigitConfig config;
  DateTime startTime;
  
  int totalLength() => sections
                          .map((section) => section.length)
                          .reduce((collector,section){ collector += section; return collector;});

   int totalLengthBefore(Section section) => sections.indexOf(section) == 0 ? 0 :
                                            sections
                                            .where((s)=> sections.indexOf(s) < sections.indexOf(section))
                                            .map((s)=> s.length)
                                            .reduce((collector,value)=> collector += value);

  double initRadius (Section section) => totalLengthBefore(section)/radiusDeduction();

  double endRadius (Section section) => sections
                                            .where((s)=> sections.indexOf(s) <= sections.indexOf(section))
                                            .map((s)=> s.length)
                                            .reduce((collector,value)=> collector += value)/radiusDeduction();

  double radiusDeduction() => totalLength()/config.delta();

  double angleBeforeSection (Section section) => (totalLengthBefore(section) + calculateStartRotation(startTime)) * MILLIS_TO_ANGLE;

  int calculateStartRotation(DateTime startTime) => (startTime.minute - 15) * 1000 * 60 + (startTime.second * 1000);
  
}