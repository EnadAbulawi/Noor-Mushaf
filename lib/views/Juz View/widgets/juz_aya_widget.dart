import 'package:alfurqan/controllers/audio_Controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/models/juz_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class JuzAyaWidget extends StatelessWidget {
  const JuzAyaWidget({
    super.key,
    required this.juzData,
    required this.settingsController,
  });

  final JuzModel? juzData;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final AudioController audioController = Get.find<AudioController>();
    return Column(
      children: [
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.r,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColor.secondaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Get.isDarkMode
                    ? AppColor.lightColor.withOpacity(0.1)
                    : AppColor.darkColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'من ${juzData!.startSurahName} إلى ${juzData!.endSurahName}',
                  style: AppFontStyle.alexandria.copyWith(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: juzData!.verses.length,
            itemBuilder: (context, index) {
              final verse = juzData!.verses[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.secondaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: Get.isDarkMode
                        ? AppColor.lightColor.withOpacity(0.1)
                        : AppColor.darkColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'آية ${verse.number}',
                              style: AppFontStyle.alexandria.copyWith(
                                fontSize: 14.sp,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                          Text(
                            verse.surahName,
                            style: AppFontStyle.alexandria.copyWith(
                              fontSize: 16.sp,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        verse.text,
                        style: AppFontStyle.kitab.copyWith(
                          fontSize: settingsController.fontSize.value,
                          // height: 1.8,
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 12.h),
                      // زر تشغيل الصوت
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
