import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomNavigation(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();
    return AnimatedContainer(
      height: 80.h,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: settingsController.isDarkMode.value
            ? AppColor.darkColor
            : AppColor.lightColor,
        boxShadow: [
          BoxShadow(
            color: Get.isDarkMode
                ? AppColor.lightColor.withOpacity(0.1)
                : AppColor.darkColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(-5, 0),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: AppFontStyle.alexandria.copyWith(fontSize: 12.sp),
        unselectedLabelStyle: AppFontStyle.alexandria.copyWith(fontSize: 12.sp),
        iconSize: 30.sp,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              HugeIcons.strokeRoundedBookOpen01,
            ),
            label: 'القرآن',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              HugeIcons.strokeRoundedHeadphones,
            ),
            label: 'الصوتيات',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              HugeIcons.strokeRoundedPrayerRug02,
            ),
            label: 'أوقات الصلاة',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              HugeIcons.strokeRoundedBookmark01,
            ),
            label: 'المحفوظات',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              HugeIcons.strokeRoundedSettings01,
            ),
            label: 'الاعدادات',
          ),
        ].reversed.toList(),
      ),
    );
  }
}
