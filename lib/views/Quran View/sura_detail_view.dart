import 'package:alfurqan/controllers/audio_Controller.dart';
import 'package:alfurqan/controllers/bookmark_controller.dart';
import 'package:alfurqan/controllers/last_read_controller.dart';
import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/models/aya_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/views/widgets/custom_suraDetail_appBar.dart';
import 'package:alfurqan/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/surah_controller.dart';
import '../widgets/aya_card_widgets.dart';
import '../widgets/header_sura_detail_widget.dart';
import 'package:alfurqan/views/widgets/audio_player_widget.dart';
import 'widgets/show_aya_as_quran.dart'; // استدعاء ويدجت مشغل الصوت

class SurahDetailView extends StatelessWidget {
  final SurahController surahController = Get.find();
  final SettingsController settingsController = Get.find();
  final BookmarkController bookmarkController = Get.find();
  final AudioController audioController = Get.find();
  final LastReadController lastReadController = Get.find();
  final int? initialAyahNumber;
  SurahDetailView({this.initialAyahNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? AppColor.darkColor : AppColor.dayColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomSuraDetailViewAppBar(
              audioController: audioController,
              surahController: surahController,
              settingsController: settingsController,
            ),
            Expanded(
              child: Obx(() {
                if (surahController.isAyahLoading.value) {
                  return Center(child: CustomLoading());
                }

                if (surahController.isRichTextMode.value) {
                  return ShowAyaAsQuran(
                    surahController: surahController,
                    settingsController: settingsController,
                  );
                }

                return Column(
                  children: [
                    // Obx(() => Visibility(
                    //       replacement: const SizedBox(
                    //         height: 0,
                    //         child: Divider(
                    //           color: Colors.white,
                    //           thickness: 0.2,
                    //           height: 5,
                    //         ),
                    //       ),
                    //       visible: surahController.isHeaderVisible.value,
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             vertical: 5, horizontal: 12),
                    //         child: HeaderSuraInformation(
                    //             surahController: surahController),
                    //       ),
                    //     )),
                    Expanded(
                      child: ListView.builder(
                        controller: surahController.scrollController,
                        itemCount: surahController.ayahs.length,
                        itemBuilder: (context, index) {
                          Ayah ayah = surahController.ayahs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            child: AyaCardWidgets(
                              audioController: audioController,
                              bookMarkController: bookmarkController,
                              ayah: ayah,
                              settingsController: settingsController,
                              surahController: surahController,
                              lastReadController: lastReadController,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
            AudioPlayerWidget(),
          ],
        ),
      ),
    );
  }
}
