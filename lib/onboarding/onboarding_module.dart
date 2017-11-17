import 'package:flutter/material.dart';
import 'package:Robopomodoro/onboarding/onboarding_widget.dart';

var onboardingPageController = new PageController();

var onboardingStateFactory = () => new OnboardingState(onboardingPageController);

var onboardingWidget  = (VoidCallback callback) => new OnboardingWidget(onComplete:callback,stateFactory: onboardingStateFactory);
