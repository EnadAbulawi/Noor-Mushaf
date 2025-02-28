import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class JuzCardWidget extends StatelessWidget {
  final int juzNumber;
  final String juzName;
  final VoidCallback onTap;
  const JuzCardWidget(
      {super.key,
      required this.juzNumber,
      required this.juzName,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Get.isDarkMode
                ? AppColor.lightColor.withOpacity(0.3)
                : AppColor.darkColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' $juzNumber',
              style: AppFontStyle.alexandria.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.secondaryColor,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'الجزء',
              style: AppFontStyle.alexandria.copyWith(
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
