import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCheck {
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }
}
