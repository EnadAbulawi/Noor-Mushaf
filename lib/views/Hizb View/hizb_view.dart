import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/hizb_controller.dart';

class HizbView extends StatelessWidget {
  final HizbController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? AppColor.darkColor : AppColor.lightColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CustomLoading());
        }
        return GridView.builder(
          padding: EdgeInsets.all(16.r),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 3.5.w,
          ),
          itemCount: 60,
          itemBuilder: (context, index) {
            final hizbNumber = (index ~/ 4) + 1;
            final quarterNumber = (index % 4) + 1;
            return Container(
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.loadHizbQuarter(index + 1),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'الربع $quarterNumber',
                        style: AppFontStyle.alexandria.copyWith(
                          fontSize: 14.sp,
                          color: AppColor.primaryColor.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '$hizbNumber',
                        style: AppFontStyle.alexandria.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          // color: AppColor.primaryColor,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'الحزب',
                        style: AppFontStyle.alexandria.copyWith(
                          fontSize: 18.sp,
                          // color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
