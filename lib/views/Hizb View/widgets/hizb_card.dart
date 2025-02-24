import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HizbCard extends StatelessWidget {
  final int hizbNumber;
  final int quarterNumber;
  final VoidCallback onTap;

  const HizbCard({
    required this.hizbNumber,
    required this.quarterNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'حزب',
              style: AppFontStyle.alexandria.copyWith(
                fontSize: 18.sp,
                color: AppColor.primaryColor,
              ),
            ),
            Text(
              '$hizbNumber',
              style: AppFontStyle.alexandria.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            Text(
              'ربع $quarterNumber',
              style: AppFontStyle.alexandria.copyWith(
                fontSize: 16.sp,
                color: AppColor.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
