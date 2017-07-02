import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'main_module.dart';
import 'dart:ui';
import 'dart:math';

class TimerPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var backgroundColor = new Color(0xFFA4C639);
    var dialPaint = new Paint();
    dialPaint.colorFilter = new ColorFilter.mode(backgroundColor, BlendMode.srcIn);
    var dialShadowPaint = new Paint();
    dialShadowPaint.color = new Color(0x66000000);
    dialShadowPaint.maskFilter = new MaskFilter.blur(BlurStyle.normal, 8.0);
    var backgroundPaint = new Paint();
    backgroundPaint.color = backgroundColor;

    canvas.drawColor(backgroundColor, BlendMode.src );
    //canvas.drawCircle(new Offset(size.width/2, size.height/2), size.width/2, dialPaint);
    var shadowPath = frontPlate(size,280.0,180.0).transform(new Matrix4.translationValues(0.0, 6.0, 0.0).storage);
    canvas.drawPath(shadowPath,dialShadowPaint);
    canvas.drawPath(frontPlate(size,280.0,180.0),dialPaint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return false;
  }

  Path frontPlate(Size screenSize, double dialCenterHeight, double dialRadius) {
      Path shadowPath = new Path();

      shadowPath.lineTo(screenSize.width/2, 0.0);
      shadowPath.lineTo(screenSize.width/2,screenSize.height);
      shadowPath.lineTo(screenSize.width/2,dialCenterHeight + dialRadius);
      var horizontalPadding = screenSize.width/2 - dialRadius;
      var topPadding = dialCenterHeight - dialRadius;
      var bottomPadding = screenSize.height - dialCenterHeight - dialRadius;
      var dialRectangle = new Rect.fromLTRB(horizontalPadding, topPadding, screenSize.width - horizontalPadding, screenSize.height - bottomPadding);
      shadowPath.arcTo(dialRectangle, -PI/2, -PI, false);
      shadowPath.arcTo(dialRectangle, PI/2, -PI, false);
      shadowPath.lineTo(screenSize.width/2, 0.0);
      shadowPath.lineTo(screenSize.width,0.0);
      shadowPath.lineTo(screenSize.width,screenSize.height);
      shadowPath.lineTo(0.0, screenSize.height);
      shadowPath.lineTo(0.0, screenSize.height/2);
      shadowPath.lineTo(0.0, 0.0);
      return shadowPath;
  }
}
