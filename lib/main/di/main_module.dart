import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
//import 'dart:ui';

TextPainter textPainter(String label) => new TextPainter(
      text: new TextSpan(
       style: defaultTextStyle,
       text: label,
    ),
      textAlign: TextAlign.center,
      maxLines: 1,
    );


TextDecoration defaultTextDecoration = TextDecoration.none;

TextStyle defaultTextStyle = new TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: new Color(0xFF000000),
          decoration: defaultTextDecoration,
       );

TextStyle sessionTimeTextStyle = new TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.normal,
          color: new Color(0xFF000000),
          decoration: defaultTextDecoration,

);

TextStyle currentTimeTextStyle = new TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: new Color(0xFF000000),
          decoration: defaultTextDecoration,

);


DateFormat sessionTimeFormat = new DateFormat('mm:ss');
DateFormat currentTimeFormat = new DateFormat('h:mm:ss a');

Paint platePaint() {
  var paint = new Paint();
  paint.color = new Color(0xFFFFFFFF);
  return paint;
}

Paint defaultShadowPaint() {
  var paint = new Paint();
  paint.color = new Color(0x66000000);
  paint.maskFilter = new MaskFilter.blur(BlurStyle.normal, 2.0);
  return paint;
}

Paint workSectionIncompletePaint = platePaint();

Paint workSectionCompletePaint = defaultFillPaint(workSectionCompleteColor);

Paint breakSectionIncompletePaint = defaultFillPaint(breakSectionIncompleteColor);
    

Paint breakSectionCompletePaint = defaultFillPaint(breakSectionCompleteColor);

Paint minuteDigitPaint = defaultStrokePaint(darkDialColor, 2.0);

Paint centralButtonPaint = defaultFillPaint(centralButtonColor);

Paint defaultFillPaint(Color color) {
  Paint paint = new Paint();
  paint.style = PaintingStyle.fill;
  paint.color = color;
  return paint;
}

Paint defaultStrokePaint(Color color, double width) {
  Paint paint = new Paint();
  paint.strokeWidth = width;
  paint.strokeCap = StrokeCap.square;
  paint.style = PaintingStyle.stroke;
  paint.color = color;
  return paint;
}

Color workSectionIncompleteColor = new Color(0x88A4C639);
Color workSectionCompleteColor = new Color(0xFFA4C639);

Color breakSectionIncompleteColor = new Color(0x88A8CF2B);
Color breakSectionCompleteColor = new Color(0xFFA8CF2B);

Color dialColor = new Color(0xFFF0F0F0);

Color darkDialColor = new Color(0x20202020);

Color centralButtonColor = workSectionCompleteColor;

void drawDebug(Canvas canvas, Size size) {
  var increment = 20.0;
  Paint debugPaint = new Paint();
  debugPaint.color = new Color(0xFF000000);
  for (var x = 0.0; x < size.width; x += increment) {
    canvas.drawLine(new Offset(x, 0.0), new Offset(x, size.height), debugPaint);
  }
  for (var y = 0.0; y < size.height; y += increment) {
    canvas.drawLine(new Offset(0.0, y), new Offset(size.width, y), debugPaint);
  }
}

const double DEFAULT_ANGLE_CORRECTION = -PI/2;

var wrapTime = 0;
Duration warp() => new Duration(milliseconds: wrapTime += 5000);
var timeProvider = () => new DateTime.now();//.add(warp());

const MILLIS_TO_ANGLE =  2 * PI / (60 * 60 * 1000);
const double STRIPES_FACTOR = PI / (6 / 60 / 1000);

const REFRESH_TIME_MILLISECONDS = 300;

