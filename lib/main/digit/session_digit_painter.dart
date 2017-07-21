import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'dart:math';

import '../../app/models.dart';
import '../di/main_module.dart';

class SessionDigitPainter extends CustomPainter {

  static const MILLIS_TO_ANGLE =  2 * PI / (60 * 60 * 1000);
  static const double STRIPES_FACTOR = PI / (6 / 60 / 1000);

  double dialInnerRadius;
  double dialOuterRadius;

  int elapsedLength;

  List<Section> sections;

  int baseRotation;

  SessionDigitPainter({
    this.sections,
    this.dialInnerRadius,
    this.dialOuterRadius,
    this.elapsedLength,
    this.baseRotation,
  }): assert (sections != null),
      assert (sections.length > 0),
      assert (dialInnerRadius < dialOuterRadius),
      assert (dialOuterRadius > 0.0);


  @override
  void paint(Canvas canvas, Size size) {
    int lengthCounter = 0;
    for(Section section in sections) {
      double initAngle = calculateAngleBeforeSection(section);
      double initOuterRadius = dialOuterRadius - dialInnerRadius - calculateInitRadius(section);
      double initInnerRadius = dialOuterRadius - dialInnerRadius - calculateEndRadius(section);
      if(lengthCounter + section.length <= elapsedLength) {
          drawSection(
            canvas,
            section,
            initAngle: initAngle,
            initOuterRadius: initOuterRadius,
            initInnerRadius: initInnerRadius,
            paintType: _PaintType.FOREGROUND,
          );
      } else if (lengthCounter >= elapsedLength) {
          drawSection(
            canvas,
            section,
            initAngle: initAngle,
            initOuterRadius: initOuterRadius,
            initInnerRadius: initInnerRadius,
            paintType: _PaintType.BACKGROUND,
          );
      } else {
          Section completedSection = new Section(
            length: elapsedLength - lengthCounter,
            sessionType: section.sessionType,
            foregroundPaint: section.foregroundPaint,
            backgroundPaint: section.backgroundPaint,
          );
          Section incompleteSection = new Section(
            length: section.length - (elapsedLength - lengthCounter),
            sessionType: section.sessionType,
            foregroundPaint: section.foregroundPaint,
            backgroundPaint: section.backgroundPaint,
          );
          drawSection(
            canvas,
            completedSection,
            initAngle: initAngle,
            initOuterRadius: initOuterRadius,
            initInnerRadius: initInnerRadius + (initOuterRadius - initInnerRadius) * (1 - completedSection.length / section.length),
            paintType: _PaintType.FOREGROUND,
          );
          drawSection(
            canvas,
            incompleteSection,
            initAngle: initAngle + completedSection.length * MILLIS_TO_ANGLE,
            initOuterRadius: initInnerRadius + (initOuterRadius - initInnerRadius) * (1 - completedSection.length / section.length),
            initInnerRadius: initInnerRadius,
            paintType: _PaintType.BACKGROUND,
          );
      }
      lengthCounter += section.length;
    }

  }

  bool shouldRepaint(SessionDigitPainter oldDelegate) {
    return false;
  }

  Section calculateSessionTotal() {
    int totalLength = 0;
    totalLength = sections.map((s)=>s.length).fold(totalLength,(v,e){return v+=e;});
    return new Section(length: totalLength,foregroundPaint: defaultShadowPaint(), backgroundPaint: defaultShadowPaint(), sessionType: SectionType.WORK);

  }

  void drawSection(Canvas canvas, Section session, {double initAngle, double initOuterRadius, double initInnerRadius, _PaintType paintType}) {

    int numberOfStripes = calculateNumberOfStripes(session);
    double stripeAngle = session.length / numberOfStripes * MILLIS_TO_ANGLE;
    double radiusDeduction = (initOuterRadius - initInnerRadius)/numberOfStripes;
    List<Stripe> stripes = new List();
    for(int i = 0; i < numberOfStripes; i ++) {
      stripes.add(calculateStripe(initAngle + stripeAngle * i, stripeAngle, initOuterRadius - radiusDeduction * i, initOuterRadius - radiusDeduction * (i + 1)));
    }
    Path path = stripePathBuilder(stripes);
    Paint selectedPaint = paintType == _PaintType.FOREGROUND ? session.foregroundPaint : session.backgroundPaint;
    canvas.drawPath(path, selectedPaint);

  }

  int calculateNumberOfStripes(Section section) {
      return calculateTotalLengthForSection(sections.length) ~/ STRIPES_FACTOR;
  }

  double calculateStripeWidth(Section section) {
    return section.length / calculateNumberOfStripes(section);
  }

  double calculateInitRadius(Section section) {
    int initialValue = 0;
    int lengthOfSectionsBefore = (sections.where((s){
      return sections.indexOf(s) < sections.indexOf(section);
    }).map((s)=> s.length).fold(initialValue,(v,e){v+=e; return v;}));
    return lengthOfSectionsBefore / calculateRadiusDeduction();
  }

  double calculateEndRadius(Section section) {

    int initialValue = 0;
    int lengthOfSectionsBefore = (sections.where((s){
      return sections.indexOf(s) <= sections.indexOf(section);
    }).map((s)=> s.length).fold(initialValue,(v,e){v+=e; return v;}));
    return lengthOfSectionsBefore / calculateRadiusDeduction();
  }


  double calculateRadiusDeduction() {
    int totalLength = sections.map((s)=>s.length).reduce((v,e){
      v +=e;
      return v;
    });
    double deltaHeight = dialOuterRadius - dialInnerRadius;
    return totalLength  / deltaHeight;
  }

  int calculateTotalLengthForSection(int indexOfSection) {
    if(indexOfSection == 0) {
      return 0;
    }
    int initialValue = 0;
    return sections.where((s) { return sections.indexOf(s)<indexOfSection; })
      .fold(initialValue,(v,e){v +=e.length; return v;});
  }

  double calculateAngleBeforeSection(Section section) {
    int indexOfSection = sections.indexOf(section);
    int totalLengthBefore = calculateTotalLengthForSection(indexOfSection);
    return (baseRotation + totalLengthBefore) * MILLIS_TO_ANGLE;
  }



  void drawStripe(Canvas canvas, Stripe stripe, Paint paint){
    Path path = new Path();
    path.moveTo(stripe.beginBottom.x, stripe.beginBottom.y);
    path.lineTo(stripe.beginTop.x, stripe.beginTop.y);
    path.lineTo(stripe.endTop.x, stripe.endTop.y);
    path.lineTo(stripe.endBottom.x,stripe.endBottom.y);
    path.lineTo(stripe.beginBottom.x,stripe.beginBottom.y);
    canvas.drawPath(path, paint);
  }


  double calculateAngleForSection(Section section) {
    return section.length * MILLIS_TO_ANGLE;
  }

Stripe calculateStripe(double initAngle, double stripeAngle, double radiusTop, double radiusBottom) {
    return new Stripe(
      beginBottom: new Point(cos(initAngle) * dialInnerRadius,sin(initAngle) * dialInnerRadius),
      beginTop: new Point(cos(initAngle) * (dialInnerRadius + radiusTop), sin(initAngle) * (dialInnerRadius + radiusTop)),
      endTop: new Point(cos(stripeAngle + initAngle) * (dialInnerRadius + radiusBottom), sin(stripeAngle + initAngle) * (dialInnerRadius + radiusBottom)),
      endBottom: new Point(cos(stripeAngle + initAngle) * dialInnerRadius, sin(stripeAngle + initAngle) * dialInnerRadius),
    );
  }

  Path stripePathBuilder(List<Stripe> stripeList) {
    Path path = new Path();
    path.moveTo(stripeList[0].beginBottom.x, stripeList[0].beginBottom.y);
    path.lineTo(stripeList[0].beginTop.x, stripeList[0].beginTop.y);
    for(var i = 0; i < stripeList.length; i++){
      path.lineTo(stripeList[i].endTop.x,stripeList[i].endTop.y);
    }
    path.lineTo(stripeList[stripeList.length - 1].endBottom.x, stripeList[stripeList.length - 1].endBottom.y);
    for(var i = stripeList.length -1; i >= 0; i--) {
      path.lineTo(stripeList[i].beginBottom.x, stripeList[i].beginBottom.y);
    }

    return path;
}

}

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

enum _PaintType {
  FOREGROUND,BACKGROUND,
}
