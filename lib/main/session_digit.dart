import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'dart:math';

import '../app/models.dart';
import '../main/main_module.dart';

class SessionPainter extends CustomPainter {

  static const MILLIS_TO_ANGLE =  2 * PI / (60 * 60 * 1000);
  static const double STRIPES_FACTOR = PI / (6 / 60 / 1000);

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
    drawSection(canvas,calculateSessionTotal(),defaultShadowPaint());
    for(Section section in sections) {
      drawSection(canvas,section,_paintForColors(section.color));
    }

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

  void drawSection(Canvas canvas, Section session,Paint paint) {

    int numberOfStripes = calculateNumberOfStripes(session);
    double stripeAngle = session.length / numberOfStripes * MILLIS_TO_ANGLE;
    double radiusDeduction = (dialOuterRadius - dialInnerRadius)/numberOfStripes;
    double initRadius = 0.0;
    List<Stripe> stripes = new List();
    for(int i = 0; i < numberOfStripes; i ++) {
      stripes.add(calculateStripe(stripeAngle * i, stripeAngle,initRadius,radiusDeduction * i, radiusDeduction * (i + 1)));
    }
    Path path = stripePathBuilder(stripes, stripeAngle);
    canvas.drawPath(path, paint);

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


Stripe calculateStripe(double initAngle, double stripeAngle, double initRadius, double radiusDeductionTop, double radiusDeductionBottom) {
    return new Stripe(
      beginBottom: new Point(cos(initAngle) * dialInnerRadius,sin(initAngle) * dialInnerRadius),
      beginTop: new Point(cos(initAngle) * (dialOuterRadius - initRadius - radiusDeductionTop), sin(initAngle) * (dialOuterRadius - initRadius - radiusDeductionTop)),
      endTop: new Point(cos(stripeAngle + initAngle) * (dialOuterRadius - initRadius - radiusDeductionBottom), sin(stripeAngle + initAngle) * (dialOuterRadius - initRadius - radiusDeductionBottom)),
      endBottom: new Point(cos(stripeAngle + initAngle) * dialInnerRadius, sin(stripeAngle + initAngle) * dialInnerRadius),
    );
  }

  Path stripePathBuilder(List<Stripe> stripeList, double stripeRotation) {
    Path path = new Path();
    path.moveTo(stripeList[0].beginBottom.x, stripeList[0].beginBottom.y);
    path.lineTo(stripeList[0].beginTop.x, stripeList[0].beginTop.y);
    for(var i = 0; i < stripeList.length; i++){
      path.lineTo(stripeList[i].endTop.x,stripeList[i].endTop.y);
    }
    path.lineTo(stripeList[stripeList.length - 1].endBottom.x, stripeList[stripeList.length - 1].endBottom.y);
    for(var i = stripeList.length -1; i > 0; i--) {
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
