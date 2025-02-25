import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/utils/app_color.dart';

void showCustomSnackbar({
  required String title,
  required String message,
  Color? backgroundColor, // لون الخلفية (اختياري)
  Gradient? backgroundGradient, // التدرج اللوني (اختياري)
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 4),
  EdgeInsets margin = const EdgeInsets.all(16),
  Curve forwardAnimationCurve = Curves.easeOutQuad,
  Curve reverseAnimationCurve = Curves.fastLinearToSlowEaseIn,
  Duration animationDuration = const Duration(seconds: 1),
  double borderRadius = 12,
  SnackStyle snackStyle = SnackStyle.FLOATING,
  Widget? icon,
}) {
  // التدرج اللوني الافتراضي
  final Gradient defaultGradient = const LinearGradient(
    colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
    begin: Alignment(-0.71, 0.71),
    end: Alignment(0.71, -0.71),
  );

  // تحديد الخلفية بناءً على المعاملات الممررة
  final Color? finalBackgroundColor = backgroundColor;
  final Gradient? finalBackgroundGradient = backgroundGradient ??
      (finalBackgroundColor == null ? defaultGradient : null);

  Get.snackbar(
    title,
    message,
    titleText: Text(
      title,
      textAlign: TextAlign.end,
      style: AppFontStyle.alexandria.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
    ),
    messageText: Text(
      message,
      textAlign: TextAlign.end,
      style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp),
    ),
    backgroundColor: finalBackgroundColor, // لون الخلفية (يمكن أن يكون null)
    snackPosition: snackPosition,
    duration: duration,
    margin: margin,
    forwardAnimationCurve: forwardAnimationCurve,
    reverseAnimationCurve: reverseAnimationCurve,
    animationDuration: animationDuration,
    borderRadius: borderRadius,
    snackStyle: snackStyle,
    backgroundGradient:
        finalBackgroundGradient, // التدرج اللوني (يمكن أن يكون null)
    icon: icon ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedNotification01,
            color: AppColor.lightColor,
            size: 28.sp,
          ),
        ),
  );
}
