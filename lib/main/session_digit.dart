import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'dart:math';

import '../app/models.dart';
import '../main/main_module.dart';

class SessionPainter extends CustomPainter {

  static const MILLIS_TO_ANGLE =  2 * PI / (60 * 60 * 1000);
  static const double STRIPES_FACTOR = PI / (1 / 60 / 1000);

  List<Paint> sectionPaints;

  double dialInnerRadius;
  double dialOuterRadius;

  List<Section> sections;

  SessionPainter({
    this.sections,
    this.dialInnerRadius,
    this.dialOuterRadius,
  }): assert (sections != null),
      assert (sections.length > 0),
      assert (dialInnerRadius < dialOuterRadius),
      assert (dialOuterRadius > 0.0);


  @override
  void paint(Canvas canvas, Size size) {
    _debug();
    canvas.save();
    for(Section section in sections) {
          drawSection(section, canvas);
    }
    canvas.restore();
    //drawSessionShadow(canvas);

  }

  @override
  bool shouldRepaint(SessionPainter oldDelegate) {
    return false;
  }

  Section calculateSessionTotal() {
    int totalLength = 0;
    totalLength = sections.map((s)=>s.length).fold(totalLength,(v,e){return v+=e;});
    return new Section(length: totalLength,color: new Color(0x33000000), sessionType: SectionType.WORK);

  }

  void drawSessionShadow(Canvas canvas) {

    Section session = calculateSessionTotal();
    int numberOfStripes = calculateNumberOfStripes(session);
    double stripeAngle = session.length / numberOfStripes * MILLIS_TO_ANGLE;
    double radiusDeduction = (dialOuterRadius - dialInnerRadius)/session.length;
    double initRadius = 0.0;
    for(int i = 0; i < numberOfStripes; i ++) {
      Stripe stripe = calculateStripe(stripeAngle,initRadius,radiusDeduction * i, radiusDeduction * (i + 1));
      drawStripe(canvas, stripe, defaultShadowPaint());
      canvas.rotate(stripeAngle);
    }
  }

  void drawSection(Section section, Canvas canvas) {
    double fullAngle = calculateAngleForSection(section);
    int numberOfStripes = calculateNumberOfStripes(section);
    double stripeAngle = calculateStripeWidth(section) * MILLIS_TO_ANGLE; // reduce to radians
    double initRadius = calculateInitRadius(section);
    double radiusDeduction = (calculateEndRadius(section) - initRadius) / numberOfStripes;

    print("fullAngle $fullAngle");
    print("no of stripes $numberOfStripes");

    print("init radius $initRadius");
    print("radius deduction $radiusDeduction");
    for(int i = 0; i < numberOfStripes; i++) {
            Stripe stripe = calculateStripe(stripeAngle, initRadius, radiusDeduction * i, radiusDeduction * (i+1));
      drawStripe(canvas, stripe, _paintForColors(section.color));
      canvas.rotate(stripeAngle);
    }

  }

  Stripe calculateStripe(double stripeAngle, double initRadius, double radiusDeductionTop, double radiusDeductionBottom) {
    return new Stripe(
      beginBottom: new Point(dialInnerRadius,0.0),
      beginTop: new Point(dialOuterRadius - initRadius - radiusDeductionTop, 0.0),
      endTop: new Point(cos(stripeAngle) * (dialOuterRadius - initRadius - radiusDeductionBottom), sin(stripeAngle) * (dialOuterRadius - initRadius - radiusDeductionBottom)),
      endBottom: new Point(cos(stripeAngle) * dialInnerRadius, sin(stripeAngle) * dialInnerRadius),
    );
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

  Paint _paintForColors(Color primary) {
    Paint paint = new Paint();
    paint.color = primary;
    paint.strokeWidth = 2.0;
    paint.style = PaintingStyle.fill;
    return paint;
  }

  void _debug() {
    print("Drawing SessionPainter");
    print("dialOuterRadius $dialOuterRadius");
    print("dialInnerRadius $dialInnerRadius");
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
