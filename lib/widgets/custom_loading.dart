import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.inkDrop(
            color: Get.isDarkMode ? AppColor.lightColor : AppColor.darkColor,
            size: 60.r,
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري التحميل ...',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
