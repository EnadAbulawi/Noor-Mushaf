import 'package:alfurqan/controllers/AudioController.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class AudioPlayerWidget extends StatelessWidget {
  final AudioController audioController = Get.find();
  final SurahController surahController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (audioController.isPlaying.value) {
      } else {
        return SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 16.0.h),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColor.darkColor,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اسم السورة والآية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " ${surahController.currentSurah.value.name} - آية ${audioController.currentAyah.value}",
                        style: AppFontStyle.uthmanicHafs
                            .copyWith(color: Colors.white, fontSize: 20.sp),
                      ),
                    ],
                  ),
                  // زر الإغلاق لإخفاء المشغل
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => audioController.isPlaying(false),
                  ),
                ],
              ),

              // شريط التحكم بالصوت
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous,
                        color: Colors.white, size: 30),
                    onPressed: audioController.playPreviousAyah,
                  ),
                  IconButton(
                    icon: Icon(
                        audioController.isPaused.value
                            ? Icons.play_arrow
                            : Icons.pause,
                        color: Colors.white,
                        size: 36),
                    onPressed: audioController.qurantogglePausePlay,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, color: Colors.white, size: 30),
                    onPressed: audioController.playNextAyah,
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     // IconButton(
              //     //   icon: HugeIcon(
              //     //       icon: HugeIcons.strokeRoundedPrevious,
              //     //       color: Colors.white,
              //     //       size: 30),
              //     //   onPressed: surahController.playPreviousAyah,
              //     // ),
              //     IconButton(
              //       icon: HugeIcon(
              //         icon: surahController.isPaused.value
              //             ? HugeIcons.strokeRoundedPlay
              //             : HugeIcons.strokeRoundedPause,
              //         color: Colors.white,
              //         size: 36,
              //       ),
              //       onPressed: surahController.togglePausePlay,
              //     ),
              //     IconButton(
              //       icon: HugeIcon(
              //           icon: HugeIcons.strokeRoundedNext,
              //           color: Colors.white,
              //           size: 30),
              //       onPressed: surahController.playNextAyah,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      );
    });
  }
}
