import 'package:flutter_test/flutter_test.dart';
import 'package:Robopomodoro/main/digit/path_builder.dart';
import 'package:Robopomodoro/main/models.dart';
import 'dart:math';

import 'session_widget_model_mock.dart';


void main(){

const double INNER_RADIUS = 50.0;

    SessionWidgetModel mockModel = new SessionWidgetModel()
        ..config = mockConfig
        ..startTime = mockTime
        ..session = mockSession;

    PathBuilder pathBuilderUnderTest = new PathBuilder(mockConfig, mockModel);

    test(
      "GIVEN stripe angle WHEN stripe is calculated THEN returned stripe consist four corners of the stripe defined by angle and inner and outer radius",
      () {
    Stripe stripe =
        pathBuilderUnderTest.createStripe(0.0, pi / 2, 50.0, 40.0);

    expect(stripe.beginBottom.x, INNER_RADIUS);
    expect(stripe.beginBottom.y, 0.0);

    expect(stripe.beginTop.x, 100.0);
    expect(stripe.beginTop.y, 0.0);

    expect(stripe.endTop.x.abs() < 0.000001, true);
    expect(stripe.endTop.y, 90.0);

    expect(stripe.endBottom.x.abs() < 0.000001, true);
    expect(stripe.endBottom.y, INNER_RADIUS);
  });
}