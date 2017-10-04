import 'dart:ui';
import 'package:flutter/rendering.dart';

import 'dart:math';
import '../models.dart';
import '../../app/models.dart';
import '../di/main_module.dart';


class PathBuilder {

  SessionDigitConfig _sessionDigitConfig;

  SessionWidgetModel _sessionWidgetModel;

  PathBuilder (this._sessionDigitConfig,this._sessionWidgetModel);

  Path buildPath(Section section,{Size size, double initAngle, double initOuterRadius, double initInnerRadius}) {
      Path path = _buildPathFromStripes(_stripes(section,initAngle: initAngle,initOuterRadius: initOuterRadius, initInnerRadius: initInnerRadius));
      path = path.transform(new Matrix4.translationValues(size.width/2, size.height/2, 0.0).storage);
      return path;
  }
/// Builds path given list of Stripes
  Path _buildPathFromStripes(List<Stripe> stripeList) {
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

  List<Stripe> _stripes (Section section,{double initAngle, double initOuterRadius, double initInnerRadius}) {
    int numberOfStripes = stripeCount(section);
    double rD = (initOuterRadius - initInnerRadius)/numberOfStripes; 
    double sA = stripeAngle(section);
    List<Stripe> stripes = new List();
    for(int i = 0; i < numberOfStripes; i ++) {
      stripes.add(createStripe(initAngle + sA * i, sA , initOuterRadius - rD * i, initOuterRadius - rD * (i + 1)));
    }
    return stripes;
  }



  double stripeAngle(Section section) => section.length / stripeCount(section) * MILLIS_TO_ANGLE;

  /// Calculates how many stripes are required for rawing this section
  int stripeCount(Section section) => _sessionWidgetModel.totalLength() ~/ STRIPES_FACTOR;
  
  /// Calculates stripe width for the section
  double stripeWidth(Section section, List<Section> sections) => section.length / stripeCount(section);

  /// Calculates new Stripe given initial angle, stripe angle, initial radius and end radius
  Stripe createStripe(double initAngle, double stripeAngle, double radiusTop, double radiusBottom) {

    double innerRadius = _sessionDigitConfig.dialInnerRadius;

    return new Stripe(
      beginBottom: new Point(cos(initAngle) * innerRadius,sin(initAngle) * innerRadius),
      beginTop: new Point(cos(initAngle) * (innerRadius + radiusTop), sin(initAngle) * (innerRadius + radiusTop)),
      endTop: new Point(cos(stripeAngle + initAngle) * (innerRadius + radiusBottom), sin(stripeAngle + initAngle) * (innerRadius + radiusBottom)),
      endBottom: new Point(cos(stripeAngle + initAngle) * innerRadius, sin(stripeAngle + initAngle) * innerRadius),
    );
  }

}