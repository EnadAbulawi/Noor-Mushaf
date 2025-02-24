import 'package:alfurqan/controllers/settings_controller.dart';
import 'package:alfurqan/controllers/surah_controller.dart';
import 'package:alfurqan/models/surah_model.dart';
import 'package:alfurqan/utils/app_color.dart';
import 'package:alfurqan/utils/app_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Quran View/sura_detail_view.dart';
import 'sura_information_widget.dart';
import 'sura_number_widget.dart';

class ListOfSuraWidget extends StatelessWidget {
  const ListOfSuraWidget({
    super.key,
    required this.surah,
    required this.surahController,
    required this.settingsController,
  });

  final Surah surah;
  final SurahController surahController;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
      child: GestureDetector(
        onTap: () {
          surahController.setCurrentSurah(surah);
          surahController.fetchAyahs(surah.id);
          Get.to(() => SurahDetailView());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SuraNumberWidget(surah: surah),
            SuraInformationWidget(surah: surah),
            Spacer(),
            Text(surah.name,
                strutStyle: StrutStyle(
                  forceStrutHeight: true,
                  leading: 1.3.w,
                ),
                style: AppFontStyle.newQuran.copyWith(
                  color: settingsController.isDarkMode.value
                      ? Colors.white
                      : AppColor.primaryColor,
                  fontSize: 25.sp,
                  letterSpacing: 0.9.w,

                  // height: 2,
                )),
          ],
        ),
      ),
    );
  }
}

// class SuraNumberWidget extends StatelessWidget {
//   const SuraNumberWidget({
//     super.key,
//     required this.surah,
//   });

//   final Surah surah;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 45,
//       height: 45,
//       child: Stack(
//         children: [
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Container(
//               width: 45,
//               height: 45,
//               clipBehavior: Clip.antiAlias,
//               decoration: BoxDecoration(),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     'assets/numberbracket.svg',
//                     width: 45,
//                     height: 45,
//                     color: AppColor.primaryColor,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             left: surah.id < 10 ? 18 : 15,
//             top: surah.id > 99 ? 13 : 13,
//             child: Text(
//               '${surah.id}',
//               textAlign: TextAlign.center,
//               style: AppFontStyle.balooBold.copyWith(
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
