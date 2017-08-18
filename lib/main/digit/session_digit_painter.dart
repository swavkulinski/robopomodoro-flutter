import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';

import '../../app/models.dart';
import '../di/main_module.dart';

import 'path_builder.dart';
import 'models.dart';

class SessionDigitPainter extends CustomPainter {


  SessionWidgetModel _model;

  PathBuilder _pathBuilder;

  SessionDigitPainter(
    this._model,
    this._pathBuilder,
  ): assert (_model.sections != null),
      assert (_model.sections.length > 0),
      assert (_model.config.dialInnerRadius < _model.config.dialOuterRadius),
      assert (_model.config.dialOuterRadius > 0.0);

  @override
  void paint(Canvas canvas, Size size) {
    int lengthCounter = 0;
    for(Section section in _model.sections) {
      double initAngle = _model.angleBeforeSection(section);
      double initOuterRadius = _model.config.delta() - _model.initRadius(section);
      double initInnerRadius = _model.config.delta() - _model.endRadius(section);
      if(lengthCounter + section.length <= _model.elapsed) {
          // Completed section
          drawSection(
            canvas,
            section,
            initAngle: initAngle,
            initOuterRadius: initOuterRadius,
            initInnerRadius: initInnerRadius,
            paintType: _PaintType.FOREGROUND,
          );
      } else if (lengthCounter >= _model.elapsed) {
          // Incomplete section
          drawSection(
            canvas,
            section,
            initAngle: initAngle,
            initOuterRadius: initOuterRadius,
            initInnerRadius: initInnerRadius,
            paintType: _PaintType.BACKGROUND,
          );
      } else {
          // Split into two sections - completed and incomplete
          Section completedSection = new Section(
            length: _model.elapsed - lengthCounter,
            sessionType: section.sessionType,
            foregroundPaint: section.foregroundPaint,
            backgroundPaint: section.backgroundPaint,
          );
          Section incompleteSection = new Section(
            length: section.length - (_model.elapsed- lengthCounter),
            sessionType: section.sessionType,
            foregroundPaint: section.foregroundPaint,
            backgroundPaint: section.backgroundPaint,
          );
          // Draw both sections
          drawSection(
            canvas,
            completedSection,
            initAngle: initAngle,
            initOuterRadius: initOuterRadius,
            initInnerRadius: initOuterRadius * (1 - completedSection.length / section.length),
            paintType: _PaintType.FOREGROUND,
          );
          drawSection(
            canvas,
            incompleteSection,
            initAngle: initAngle + completedSection.length * MILLIS_TO_ANGLE,
            initOuterRadius: initOuterRadius * (1 - completedSection.length / section.length),
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

  /// Draws section 
  void drawSection(Canvas canvas, Section session, {double initAngle, double initOuterRadius, double initInnerRadius, _PaintType paintType}) {

    Path path = _pathBuilder.buildPath(session,initAngle: initAngle, initInnerRadius: initInnerRadius, initOuterRadius: initOuterRadius);
    Paint selectedPaint = paintType == _PaintType.FOREGROUND ? session.foregroundPaint : session.backgroundPaint;
    canvas.drawPath(path, selectedPaint);

  }
 
}

enum _PaintType {
  FOREGROUND,BACKGROUND,
}
