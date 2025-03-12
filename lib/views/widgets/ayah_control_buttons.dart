import 'package:alfurqan/controllers/audio_Controller.dart';
import 'package:alfurqan/controllers/bookmark_controller.dart';
import 'package:alfurqan/controllers/last_read_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/models/aya_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../Aya Share View/aya_image_view.dart';
import 'bookmark_button.dart';

class AyahControlButtons extends StatelessWidget {
  final Ayah ayah;
  final SurahController surahController;
  final AudioController audioController;
  final BookmarkController bookMarkController;
  final LastReadController lastReadController;

  const AyahControlButtons({
    Key? key,
    required this.ayah,
    required this.surahController,
    required this.audioController,
    required this.bookMarkController,
    required this.lastReadController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // زر مشاركة الآية
        IconButton(
          onPressed: () => Get.to(() => AyahScreenshotScreen(
                ayahText: ayah.text,
                surahName: surahController.currentSurah.value.name,
                ayahNumber: ayah.number,
                surahNumber: surahController.currentSurah.value.id,
              )),
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedShare08,
            color: AppColor.primaryColor,
            size: 25,
          ),
        ),
        // زر تشغيل الآية
        IconButton(
          onPressed: () => audioController.playAudio(
            ayah.audio!,
            ayah.number,
            surahController.currentSurah.value.id,
          ),
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedPlay,
            color: AppColor.primaryColor,
            size: 25,
          ),
        ),
        // زر تحديد الآية كعلامة
        BookmarkButton(
          ayah: ayah,
          surahController: surahController,
          bookMarkController: bookMarkController,
        ),
        // زر تحديد الآية كآخر قراءة
        IconButton(
          onPressed: () {
            lastReadController.updateLastRead(
              surahController.currentSurah.value.name,
              ayah.number,
              surahController.currentSurah.value.id,
            );
            showCustomSnackbar(
              title: 'تم',
              message: 'تم تحديد الآية كآخر قراءة',
            );
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedBookmarkAdd01,
            color: AppColor.primaryColor,
            size: 23,
          ),
        ),
      ],
    );
  }
}
