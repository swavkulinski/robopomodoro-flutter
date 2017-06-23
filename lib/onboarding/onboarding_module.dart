import "package:di/di.dart";
import 'package:flutter/material.dart';
import 'onboarding_widget.dart';

var onboardingModule = new Module()
  ..bind(OnboardingWidget)
  ..bind(PageController);
