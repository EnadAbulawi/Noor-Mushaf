import 'package:alfurqan/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 12.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: Get.isDarkMode ? AppColor.nightColor : Colors.white,
        child: child);
  }
}
