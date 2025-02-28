import 'package:alfurqan/controllers/audio_Controller.dart';
import 'package:alfurqan/controllers/bookmark_controller.dart';
import 'package:alfurqan/controllers/last_read_controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/controllers/tafseer_controller.dart';
import 'package:alfurqan/models/aya_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'aya_number_widget.dart';
import 'ayah_control_buttons.dart';

class AyaCardWidgets extends StatelessWidget {
  const AyaCardWidgets({
    super.key,
    required this.ayah,
    required this.settingsController,
    required this.surahController,
    required this.bookMarkController,
    required this.audioController,
    required this.lastReadController,
  });

  final Ayah ayah;
  final SettingsController settingsController;
  final SurahController surahController;
  final BookmarkController bookMarkController;
  final AudioController audioController;
  final LastReadController lastReadController;

  @override
  Widget build(BuildContext context) {
    final tafseerController = Get.find<TafseerController>();

    return Card(
        child: Container(
      decoration: ShapeDecoration(
        color: settingsController.isDarkMode.value
            ? Color(0xff040C23)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19646464),
            blurRadius: 20,
            offset: Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: settingsController.isDarkMode.value
                ? Color(0xff121931).withAlpha(100)
                : Color(0xff7B80AD).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AyaNumberWidget(ayah: ayah),
              ),
              Spacer(),
              AyahControlButtons(
                ayah: ayah,
                surahController: surahController,
                audioController: audioController,
                bookMarkController: bookMarkController,
                lastReadController: lastReadController,
              ),
            ],
          ),
        ),
        AyahTextWidget(
          text: ayah.text,
          fontSize: settingsController.fontSize.value,
          isDarkMode: settingsController.isDarkMode.value,
        ),
        TafseerWidget(
          settingsController: settingsController,
          tafseerController: tafseerController,
          surahController: surahController,
          ayah: ayah,
        ),
      ]),
    ));
  }
}

class TafseerWidget extends StatelessWidget {
  const TafseerWidget({
    super.key,
    required this.settingsController,
    required this.tafseerController,
    required this.surahController,
    required this.ayah,
  });

  final SettingsController settingsController;
  final TafseerController tafseerController;
  final SurahController surahController;
  final Ayah ayah;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: settingsController.isDarkMode.value
            ? Color(0xff121931).withAlpha(100)
            : Color(0xff7B80AD).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                          tafseerController.selectedTafseerName.value,
                          style: AppFontStyle.alexandria.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.primaryColor,
                          ),
                        )),
                    Text(
                      'التفسير',
                      style: AppFontStyle.alexandria.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: settingsController.isDarkMode.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Obx(() => FutureBuilder<String>(
                      key: ValueKey(tafseerController.selectedTafseerId.value),
                      future: tafseerController.getAyahTafseer(
                        surahController.currentSurah.value.id,
                        ayah.number,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          );
                        }
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return Text(
                            snapshot.data!,
                            style: AppFontStyle.alexandria.copyWith(
                              fontSize: 16.sp,
                              height: 1.8,
                              color: settingsController.isDarkMode.value
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          );
                        }
                        return Center(
                          child: Text(
                            'جاري تحميل التفسير...',
                            style: AppFontStyle.alexandria.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AyahTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool isDarkMode;

  const AyahTextWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Text(
        text,
        textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
        textAlign: TextAlign.right,
        strutStyle: StrutStyle(leading: 1.4.w),
        style: AppFontStyle.kitab.copyWith(
          fontSize: fontSize,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
