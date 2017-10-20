import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

TextDecoration defaultTextDecoration = TextDecoration.none;

TextStyle defaultTextStyle = new TextStyle(
          fontSize: 20.0,
          fontFamily: 'Merkury',
          fontWeight: FontWeight.normal,
          color: new Color(0xFF000000),
          decoration: defaultTextDecoration,
       );

TextStyle sessionTimeTextStyle = new TextStyle(
          fontSize: 42.0,
          fontFamily: 'Merkury',
          fontWeight: FontWeight.normal,
          color: new Color(0xFF000000),
          decoration: defaultTextDecoration,

);

TextStyle currentTimeTextStyle = new TextStyle(
          fontSize: 20.0,
          fontFamily: 'Merkury',
          fontWeight: FontWeight.normal,
          color: new Color(0xFF000000),
          decoration: defaultTextDecoration,

);


DateFormat sessionTimeFormat = new DateFormat('mm:ss');
DateFormat currentTimeFormat = new DateFormat('h:mm a');

platePaint() => PomodoroPaints.fillFullWhite;

defaultShadowPaint() => PomodoroPaints.shadowPaint; 

Paint breakSectionIncompletePaint = defaultFillPaint(breakSectionIncompleteColor);

Paint breakSectionCompletePaint = defaultFillPaint(breakSectionCompleteColor);

Paint minuteDigitPaint = defaultStrokePaint(darkDialColor, 2.0);

Paint tickDialPaint = defaultStrokePaint(deepDarkColor, 1.0);

double tickLength = 5.0;

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


class PomodoroColors {
  static const white_full = const Color(0xFFFFFFFF);
  static const coffee_full = const Color(0xFFB46230);
  static const work_full = const Color(0xFFB43048);
  static const recess_full = const Color(0xFFFC2B08);

  static const white_semi = const Color(0x88FFFFFF);
  static const coffee_semi = const Color(0x88B46230);
  static const work_semi = const Color(0x88B43048);
  static const recess_semi = const Color(0x88FC2B08);

  static const dark_gray_20 = const Color(0x20202020);
  static const dark_gray_40 = const Color(0x40404040);
  static const dark_gray_80 = const Color(0x80808080);
  
  }

class PomodoroPaints {
  static var fillFullWhite = defaultFillPaint(PomodoroColors.white_full);

  static var fillFullCoffee = defaultFillPaint(PomodoroColors.coffee_full);
  static var fillFullWork = defaultFillPaint(PomodoroColors.work_full);
  static var fillFullRecess = defaultFillPaint(PomodoroColors.recess_full);

  static var fillSemiCoffee = defaultFillPaint(PomodoroColors.white_semi);
  static var fillSemiWork = defaultFillPaint(PomodoroColors.work_semi);
  static var fillSemiRecess = defaultFillPaint(PomodoroColors.recess_semi);

  static var strokeGray80w2 = defaultStrokePaint(PomodoroColors.dark_gray_80, 2.0);
  static var strokeGray80w1 = defaultStrokePaint(PomodoroColors.dark_gray_80, 1.0);

  static var shadowPaint = new Paint()
    ..color = PomodoroColors.dark_gray_80
    ..maskFilter = new MaskFilter.blur(BlurStyle.normal, 2.0);
  static var highLevelShadowPaint = new Paint()
    ..color = PomodoroColors.dark_gray_80
    ..maskFilter = new MaskFilter.blur(BlurStyle.normal, 8.0);
}

Color workSectionIncompleteColor = new Color(0x88A4C639);
Color workSectionCompleteColor = new Color(0xFFA4C639);

Color breakSectionIncompleteColor = new Color(0x88A8CF2B);
Color breakSectionCompleteColor = new Color(0xFFA8CF2B);

Color dialColor = PomodoroColors.white_full;

Color darkDialColor = new Color(0x20202020);

Color deepDarkColor = new Color(0x90050505);

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

const REFRESH_TIME_MILLISECONDS = 1000;

const EdgeInsets PADDING_8 = const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0);


