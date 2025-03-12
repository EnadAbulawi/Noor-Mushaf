import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _text1Animation;
  late Animation<Offset> _text2Animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    _text1Animation = Tween<Offset>(
      begin: const Offset(-3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _text2Animation = Tween<Offset>(
      begin: Offset(2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    navigateToOnBoadringView();
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  navigateToOnBoadringView() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    Future.delayed(const Duration(seconds: 5), () {
      Get.off(() => isFirstLaunch ? OnboardingScreen() : HomeView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'assets/quranlot.json',
              fit: BoxFit.contain,
              width: 300,
              height: 300,
            ),
          ),
          SlideTransition(
            position: _text1Animation,
            child: Text(
              'مصحف نُــور',
              style: AppFontStyle.newQuran.copyWith(
                fontSize: 35.sp,
                color: AppColor.lightColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SlideTransition(
            position: _text2Animation,
            child: Text(
              '﴾ قَدْ جَاءَكُم مِّنَ اللَّهِ نُورٌ وَكِتَابٌ مُّبِينٌ ﴿',
              style: AppFontStyle.newQuran.copyWith(
                fontSize: 35.sp,
                wordSpacing: 1.5,
                color: AppColor.lightColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
