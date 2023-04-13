import 'package:bevis/pages/home/home_page.dart';
import 'package:bevis/pages/onboarding/tutorial_page.dart';
import 'package:flutter/widgets.dart';

abstract class InitialScreenFactory {
  static Widget createInitialScreen({@required bool isLoggedIn}) {
    return isLoggedIn ? HomePage() : TutorialPage();
  }
}
