import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TabbarWidget extends StatelessWidget {
  final TabController? controller;
  const TabbarWidget({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicatorColor: AppColor.primaryColor,
      indicatorWeight: 3.0,
      unselectedLabelColor: Color(0xff8789A3),
      labelColor:
          Get.isDarkMode ? AppColor.lightColor : AppColor.secondaryColor,
      tabs: [
        // Tab(
        //     child: Text(
        //   'الصوتيات',
        //   style: AppFontStyle.alexandria.copyWith(
        //     fontSize: 16.sp,
        //   ),
        // )),
        Tab(
            child: Text(
          'الاحزاب',
          style: AppFontStyle.alexandria.copyWith(
            fontSize: 16.sp,
          ),
        )),
        Tab(
            child: Text(
          'الاجزاء',
          style: AppFontStyle.alexandria.copyWith(
            fontSize: 16.sp,
          ),
        )),
        Tab(
            child: Text(
          'قائمة السور',
          style: AppFontStyle.alexandria.copyWith(
            fontSize: 16.sp,
          ),
        )),
      ],
    );
  }
}
