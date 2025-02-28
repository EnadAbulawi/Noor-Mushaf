import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/models/surah_model.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:alfurqan/views/widgets/list_of_sura_widget.dart';
import 'package:alfurqan/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SuraListViewWidget extends StatelessWidget {
  const SuraListViewWidget({
    super.key,
    required this.surahController,
    required this.settingsController,
  });

  final SurahController surahController;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (surahController.isLoading.value) {
              return Center(child: CustomLoading());
            } else if (surahController.surahs.isEmpty) {
              return Center(child: Text("لم يتم العثور على سور"));
            } else {
              return ListView.separated(
                itemCount: surahController.surahs.length,
                separatorBuilder: (context, index) => Divider(
                  color: Color(0xff7B80AD).withOpacity(0.35), // لون الفاصل
                  thickness: 0.5, // سمك الفاصل
                  height: 10, // ارتفاع الفاصل
                  indent: 20, // المسافة الافقية
                  endIndent: 20, // المسافة الجانبية
                ),
                itemBuilder: (context, index) {
                  Surah surah = surahController.surahs[index];
                  return ListOfSuraWidget(
                    surah: surah,
                    surahController: surahController,
                    settingsController: settingsController,
                  );
                },
              );
            }
          }),
        ),
      ],
    );
  }
}
