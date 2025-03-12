import 'package:alfurqan/controllers/audio_Controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/services/showcase_service.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/views/BookMark%20View/bookmark_view.dart';
import 'package:alfurqan/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomSuraDetailViewAppBar extends StatelessWidget {
  final SurahController surahController;
  final SettingsController settingsController;
  final AudioController audioController;
  CustomSuraDetailViewAppBar(
      {super.key,
      required this.surahController,
      required this.settingsController,
      required this.audioController});

  @override
  Widget build(BuildContext context) {
    final showcaseService = Get.find<ShowcaseService>();

    // // بدء العرض التوضيحي بعد تأخير 3 ثوانٍ
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   //  await showcaseService.isShowcaseShown('search');
    //   if (!showcaseService.isShowCaseShown.value) {
    //     FeatureDiscovery.discoverFeatures(
    //       context,
    //       const <String>{
    //         'quranMode', // معرف العرض التوضيحي
    //       },
    //     );
    //     // await showcaseService.setShowcaseShown('search'); // حفظ الحالة
    //   }
    // });

    return Row(
      children: [
        IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedSetting07,
            color: settingsController.isDarkMode.value
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () {
            Get.to(() => SettingsView()); // الانتقال إلى صفحة الإعدادات
          },
        ),
        IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedBookmark01,
            color: settingsController.isDarkMode.value
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () {
            Get.to(() => BookmarksView()); // الانتقال إلى صفحة الإعدادات
          },
        ),
        IconButton(
          icon: Obx(
            () {
              return surahController.isRichTextMode.value
                  ? HugeIcon(
                      icon: HugeIcons.strokeRoundedListView, // أيقونة الإيقاف
                      color: settingsController.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                    )
                  : HugeIcon(
                      icon: HugeIcons.strokeRoundedQuran01, // أيقونة التشغيل
                      color: settingsController.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                    );
            },
          ),
          onPressed: () {
            surahController.toggleViewMode();
          },
        ),
        IconButton(
          icon: Obx(() {
            return audioController.isPlaying.value
                ? HugeIcon(
                    icon: HugeIcons.strokeRoundedPause, // أيقونة الإيقاف
                    color: settingsController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  )
                : HugeIcon(
                    icon: HugeIcons.strokeRoundedPlay, // أيقونة التشغيل
                    color: settingsController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  );
          }),
          onPressed: audioController.playFullSurah,
        ),
        Spacer(),
        Text(
          surahController.currentSurah.value.name,
          style: AppFontStyle.uthmanicHafs.copyWith(
            fontSize: 25.sp,
          ),
        ),
        SizedBox(
          width: 12.w,
        )
      ],
    );
  }
}
