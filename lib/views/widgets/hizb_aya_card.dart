import 'package:alfurqan/controllers/audio_Controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/models/aya_model.dart';
import 'package:alfurqan/models/surah_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class HizbAyaCard extends StatelessWidget {
  final Ayah ayah;
  final AudioController audioController;
  final String surahName;

  const HizbAyaCard({
    required this.ayah,
    required this.audioController,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Get.isDarkMode
              ? AppColor.lightColor.withOpacity(0.1)
              : AppColor.darkColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'آية ${ayah.number}',
                  style: AppFontStyle.alexandria.copyWith(
                    fontSize: 14.sp,
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
              Text(
                ' $surahName',
                style: AppFontStyle.alexandria.copyWith(
                  fontSize: 16.sp,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // نص الآية
          Text(
            ayah.text,
            style: AppFontStyle.kitab.copyWith(
              fontSize: settingsController.fontSize.value,
              height: 1.8,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 12.h),
          // زر تشغيل الصوت
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => audioController.playAudio(
                ayah.audio ?? '',
                ayah.number,
                ayah.surahNumber,
              ),
              icon: Icon(
                HugeIcons.strokeRoundedPlay,
                color: AppColor.primaryColor,
                size: 30.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
